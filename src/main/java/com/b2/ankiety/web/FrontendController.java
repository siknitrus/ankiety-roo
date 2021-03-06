package com.b2.ankiety.web;

import java.security.Principal;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.TypedQuery;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.b2.ankiety.AnswerSearchCriteria;
import com.b2.ankiety.model.Answer;
import com.b2.ankiety.model.Choice;
import com.b2.ankiety.model.Division;
import com.b2.ankiety.model.Person;
import com.b2.ankiety.model.Question;
import com.b2.ankiety.model.Subdivision;

@RequestMapping("/frontend/**")
@Controller
public class FrontendController {

	private static Logger logger = LoggerFactory.getLogger(FrontendController.class);

	@RequestMapping(value = "/szukaj", method = RequestMethod.GET)
	public String szukaj(ModelMap uiModel, Principal principal, HttpServletResponse response) {
		List<Division> divisions = Division.findAllDivisionsOrderById();
    	uiModel.addAttribute("divisions", divisions);
		return "frontend/search";
	}
	
	@RequestMapping(value = "/szukaj", method = RequestMethod.POST)
	public String szukajPost(ModelMap uiModel, Principal principal, HttpServletResponse response, HttpServletRequest request) {
		Set<AnswerSearchCriteria> ids = AnswerSearchCriteria.getSearchIds(request);
		
		if (ids.size()==0) {
			uiModel.put("people", Person.findAllPeople());
		} else {
			uiModel.put("people", Person.findPersonsByCriteria(ids));
		}

		return "frontend/list";
	}
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
    public String index(ModelMap uiModel, Principal principal, HttpServletResponse response) {
		
		String username = principal.getName();
		
		logger.debug("Username = " + username);
		
		List<Division> divisions = Division.findAllDivisionsOrderById();
		
		List<Person> peopleList = Person.findPeopleByUsernameEquals(username).getResultList();

		if (peopleList.size()==1) {
			Person p = peopleList.get(0);
			logger.debug(p.toString());
		
			//zaznaczam wybrane wsześniej odpowiedzi
			for (Division div : divisions) {
				for (Subdivision sub : div.getSubdivisions()) {
					for (Question q : sub.getQuestions()) {
						List<Answer> answers = Answer.findAnswersByQuestionAndPerson(q, p).getResultList();
						if (answers.size() == 1) {
							q.setTransientAnswer(answers.get(0));
						} else if (answers.size() > 1) {
							throw new RuntimeException("Bład relacji w bazie danych.");
						}
					}
				}
			}
		}
		
    	uiModel.addAttribute("divisions", divisions);
    	
        return "frontend/index";
    }
   
	@RequestMapping(value = "/", method = RequestMethod.POST)
    public String save(HttpServletRequest request, ModelMap uiModel, Principal principal) {
    	
		String username = principal.getName();

		zapisz(username, request);
		return "frontend/post";
    }    
	
	@RequestMapping(value = "/person", method = RequestMethod.GET)
	public String person(ModelMap uiModel, @RequestParam(value = "id", required = true) Long id) {
		Person p = Person.findPerson(id);
		
		List<Answer> answers = Answer.findAnswersByPerson(p).getResultList();
		
		for (Answer a : answers) {
			Subdivision s = Subdivision.findSubdivisionsByQuestions(new HashSet<Question>(Arrays.asList(a.getQuestion()))).getSingleResult();
			//a.getQuestion().setSubdivision(s);
			a.getQuestion().setDivision(Division.findDivisionsBySubdivisions(new HashSet<Subdivision>(Arrays.asList(s))).getSingleResult());
		}
		
		uiModel.addAttribute("person", p);
    	uiModel.addAttribute("answers", answers);
		
		return "frontend/person";
	}	
	
	private void zapisz(String username, HttpServletRequest request) {

		@SuppressWarnings("rawtypes")
		Enumeration e = request.getParameterNames();
		while (e.hasMoreElements()) {
			String name = (String) e.nextElement();
			String value = request.getParameter(name);

			logger.trace("Param: " + name + " = " + value);
			
            if (name.startsWith("q_")) {
            	String questionId = name.substring(2);
            	logger.trace("QuestionId: " + questionId);
            	
            	if (value.equals("0") && request.getParameter("i_" + questionId)==null) {
            		logger.trace("Pusty rekord (value==0 lub i_?==null).");
            		continue;
            	}
            	
            	Person p = Person.findPersonByUsernameOrCreate(username);
            	logger.trace(p.toString());
            	Question q = Question.findQuestion(Long.parseLong(questionId));
            	logger.trace(q.toString());
            	Answer a = null;
            	
            	TypedQuery<Answer> answers = Answer.findAnswersByQuestionAndPerson(q, p).setMaxResults(1);
        		if (answers.getResultList().size()==0) {
        			a = new Answer();
        		} else {
        			a = answers.getSingleResult();
        		}
            	            	
            			
            	if (value.equals("0")) {
            		a.setChoice(null);
            	} else {
		        	Choice c = Choice.findChoice(Long.parseLong(value));
		        	logger.trace(c.toString());
		        	a.setChoice(c);
            	}
            	
            	a.setPerson(p);
            	a.setQuestion(q);
            	a.setInterested(request.getParameter("i_" + questionId)!=null);
            	
            	logger.debug(a.toString());
            	a.persist();
            }
		}		
		
	}	
	
	
}
