/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.trabalhopraticoid_joaorosa;

import java.util.List;
import org.jdom2.Attribute;
import org.jdom2.Document;
import org.jdom2.Element;

/**
 *
 * @author joaor
 */
public class ModeloXML {
    
    public static Document adicionaPais(Pais pais, Document doc){
        Element raiz;
        if (doc == null) {
            raiz = new Element("paises"); //cria <paises>...</paises> 
            doc = new Document(raiz);
        } else {
            raiz = doc.getRootElement();
        }
        Element pai = new Element("paisDados");
        
        
        Attribute nome = new Attribute("nome", pais.getNome());
        pai.setAttribute(nome);
        
        Element filho = new Element("pais").addContent(pais.getNome());
        pai.addContent(filho);
        
       
       
        filho = new Element("capital").addContent(pais.getCapital());
        pai.addContent(filho);
        
        
        filho = new Element("bandeira").addContent(pais.getBandeira());
        pai.addContent(filho);
        
       
        filho = new Element("linguas");
        pai.addContent(filho);
        for(int i=0; i<pais.getLingua().size();i++){
            Element filho2 = new Element("lingua").addContent((String)pais.getLingua().get(i));
            filho.addContent(filho2);
        }
        
        filho = new Element("area").addContent(pais.getArea());
        pai.addContent(filho);
        
        filho = new Element("populacao").addContent(pais.getHabitantes());
        pai.addContent(filho);
        
        filho = new Element("densidade").addContent(pais.getDensidade());
        pai.addContent(filho);
        
        filho = new Element("chefe_estado").addContent(pais.getPresidente());
        pai.addContent(filho);
        
        filho = new Element("religioes");
        pai.addContent(filho);
        for(int k=0; k<pais.getReligioes().size();k++){
            Element filho2 = new Element("religiao").addContent((String)pais.getReligioes().get(k));
            filho.addContent(filho2);
        }
        
        filho = new Element("cidades_importantes");
        pai.addContent(filho);
        for(int j=0; j<pais.getCidades().size();j++){
            Element filho2 = new Element("cidade").addContent((String)pais.getCidades().get(j));
            filho.addContent(filho2);
        }
        
        filho = new Element("fronteiras");
        pai.addContent(filho);
        for(int z=0; z<pais.getFronteiras().size();z++){
            Element filho2 = new Element("pais_fronteira").addContent((String)pais.getFronteiras().get(z));
            filho.addContent(filho2);
        }
      
        
        filho = new Element("casos_covid").addContent(pais.getCasos_covid());
        pai.addContent(filho);
        
        raiz.addContent(pai);
        return doc;
        
    }
    
    
    
    public static Document removePais(String procura, Document doc) {
        Element raiz;
        if (doc == null) {
            System.out.println("Ficheiro nao existe");
            return null;
        } else {
            raiz = doc.getRootElement();
        }

        List todos = raiz.getChildren("paisDados");
        boolean found = false;
        for (int i = 0; i < todos.size(); i++) {
            Element esc = (Element) todos.get(i);
            if (esc.getAttributeValue("nome").contains(procura)) {
                esc.getParent().removeContent(esc);
                System.out.println("Pais removido com sucesso!");
                found = true;
            }
        }
        if (!found) {
            System.out.println("Pais " + procura + " não foi encontrado");
            return null;
        }
        return doc;
    }
    
    public static Document alteraCapital(String pais, String novaCap, Document doc){
        Element raiz;
        if (doc == null) {
            System.out.println("Ficheiro nao existe");
            return null;
        } else {
            raiz = doc.getRootElement();
        }
        
        List todos = raiz.getChildren("paisDados");//-------------
        boolean found = false;
        
         for(int i=0; i<todos.size(); i++){
            Element esc = (Element) todos.get(i);
            if(esc.getAttributeValue("nome").contains(pais)){
                String cap = esc.getChildText("capital");
                System.out.println("Capital atual: "+cap);
                esc.getChild("capital").setText(novaCap);
                System.out.println("Capital alterada para: "+novaCap);
                found= true;
            }
        }
        
        if (!found) {
            System.out.println("nao foi encontrado");
            return null;
        }
        return doc;
    }
    
    
    
    public static Document alteraArea(String pais, String novaA, Document doc){
        Element raiz;
        if (doc == null) {
            System.out.println("Ficheiro nao existe");
            return null;
        } else {
            raiz = doc.getRootElement();
        }
        
        List todos = raiz.getChildren("paisDados");//-------------
        boolean found = false;
        
         for(int i=0; i<todos.size(); i++){
            Element esc = (Element) todos.get(i);
            if(esc.getAttributeValue("nome").contains(pais)){
                String cap = esc.getChildText("area");
                System.out.println("Area atual: "+cap);
                esc.getChild("area").setText(novaA);
                System.out.println("Area alterada para: "+novaA);
                found= true;
            }
        }
        
        if (!found) {
            System.out.println("nao foi encontrado");
            return null;
        }
        return doc;
    }
    
    
    
    
    public static Document removeLingua(String pais, String Lingua, Document doc) {
        Element raiz;
        if (doc == null) {
            System.out.println("Ficheiro nao existe");
            return null;
        } else {
            raiz = doc.getRootElement();
        }

        List todos = raiz.getChildren("paisDados");
        boolean found = false;
        
        for (int i = 0; i < todos.size(); i++) {
            Element ele = (Element) todos.get(i);
            if (ele.getAttributeValue("nome").contains(pais)) {
                Element elem = ele.getChild("linguas");
                List lista_elemento = elem.getChildren("lingua");
                for (int j = 0; j < lista_elemento.size(); j++) {
                    Element ling = (Element) lista_elemento.get(j);
                    if (ling.getText().equals(Lingua)) {
                        ling.getParent().removeContent(ling);
                        System.out.println("Lingua removida com sucesso!");
                        found = true;
                    }
                }
            }
        }
        if (!found) {
            System.out.println("Pais " + pais + " não foi encontrado");
            return null;
        }
        return doc;
    }
    
    
    
}
