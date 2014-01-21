// WARNING: DO NOT EDIT THIS FILE. THIS FILE IS MANAGED BY SPRING ROO.
// You may push code into the target .java compilation unit if you wish to edit any member(s).

package com.b2.ankiety.web;

import com.b2.ankiety.model.Division;
import com.b2.ankiety.model.Subdivision;
import com.b2.ankiety.web.DivisionController;
import java.io.UnsupportedEncodingException;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.util.UriUtils;
import org.springframework.web.util.WebUtils;

privileged aspect DivisionController_Roo_Controller {
    
    @RequestMapping(method = RequestMethod.POST, produces = "text/html")
    public String DivisionController.create(@Valid Division division, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, division);
            return "divisions/create";
        }
        uiModel.asMap().clear();
        division.persist();
        return "redirect:/divisions/" + encodeUrlPathSegment(division.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(params = "form", produces = "text/html")
    public String DivisionController.createForm(Model uiModel) {
        populateEditForm(uiModel, new Division());
        return "divisions/create";
    }
    
    @RequestMapping(value = "/{id}", produces = "text/html")
    public String DivisionController.show(@PathVariable("id") Long id, Model uiModel) {
        uiModel.addAttribute("division", Division.findDivision(id));
        uiModel.addAttribute("itemId", id);
        return "divisions/show";
    }
    
    @RequestMapping(produces = "text/html")
    public String DivisionController.list(@RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        if (page != null || size != null) {
            int sizeNo = size == null ? 10 : size.intValue();
            final int firstResult = page == null ? 0 : (page.intValue() - 1) * sizeNo;
            uiModel.addAttribute("divisions", Division.findDivisionEntries(firstResult, sizeNo));
            float nrOfPages = (float) Division.countDivisions() / sizeNo;
            uiModel.addAttribute("maxPages", (int) ((nrOfPages > (int) nrOfPages || nrOfPages == 0.0) ? nrOfPages + 1 : nrOfPages));
        } else {
            uiModel.addAttribute("divisions", Division.findAllDivisions());
        }
        return "divisions/list";
    }
    
    @RequestMapping(method = RequestMethod.PUT, produces = "text/html")
    public String DivisionController.update(@Valid Division division, BindingResult bindingResult, Model uiModel, HttpServletRequest httpServletRequest) {
        if (bindingResult.hasErrors()) {
            populateEditForm(uiModel, division);
            return "divisions/update";
        }
        uiModel.asMap().clear();
        division.merge();
        return "redirect:/divisions/" + encodeUrlPathSegment(division.getId().toString(), httpServletRequest);
    }
    
    @RequestMapping(value = "/{id}", params = "form", produces = "text/html")
    public String DivisionController.updateForm(@PathVariable("id") Long id, Model uiModel) {
        populateEditForm(uiModel, Division.findDivision(id));
        return "divisions/update";
    }
    
    @RequestMapping(value = "/{id}", method = RequestMethod.DELETE, produces = "text/html")
    public String DivisionController.delete(@PathVariable("id") Long id, @RequestParam(value = "page", required = false) Integer page, @RequestParam(value = "size", required = false) Integer size, Model uiModel) {
        Division division = Division.findDivision(id);
        division.remove();
        uiModel.asMap().clear();
        uiModel.addAttribute("page", (page == null) ? "1" : page.toString());
        uiModel.addAttribute("size", (size == null) ? "10" : size.toString());
        return "redirect:/divisions";
    }
    
    void DivisionController.populateEditForm(Model uiModel, Division division) {
        uiModel.addAttribute("division", division);
        uiModel.addAttribute("subdivisions", Subdivision.findAllSubdivisions());
    }
    
    String DivisionController.encodeUrlPathSegment(String pathSegment, HttpServletRequest httpServletRequest) {
        String enc = httpServletRequest.getCharacterEncoding();
        if (enc == null) {
            enc = WebUtils.DEFAULT_CHARACTER_ENCODING;
        }
        try {
            pathSegment = UriUtils.encodePathSegment(pathSegment, enc);
        } catch (UnsupportedEncodingException uee) {}
        return pathSegment;
    }
    
}