/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.trabalhopraticoid_joaorosa;

import java.util.ArrayList;

/**
 *
 * @author joaor
 */
public class Pais {
    String nome;
    String capital;
    String continente;
    String bandeira;
    ArrayList lingua;
    String area;
    String habitantes;
    String densidade;
    String presidente;
    ArrayList religioes;
    ArrayList cidades;
    ArrayList fronteiras;
    String casos_covid;

    public Pais(String nome, String capital, String continente, String bandeira, ArrayList lingua, String area, String habitantes, String densidade, String presidente, ArrayList religioes, ArrayList cidades, ArrayList fronteiras, String casos_covid) {
        this.nome = nome;
        this.capital = capital;
        this.continente = continente;
        this.bandeira = bandeira;
        this.lingua = lingua;
        this.area = area;
        this.habitantes = habitantes;
        this.densidade = densidade;
        this.presidente = presidente;
        this.religioes = religioes;
        this.cidades = cidades;
        this.fronteiras = fronteiras;
        this.casos_covid = casos_covid;
    }

    public String getNome() {
        return nome;
    }

    public String getCapital() {
        return capital;
    }

    public String getContinente() {
        return continente;
    }

    public String getBandeira() {
        return bandeira;
    }

    public ArrayList getLingua() {
        return lingua;
    }

    public String getArea() {
        return area;
    }

    public String getHabitantes() {
        return habitantes;
    }

    public String getDensidade() {
        return densidade;
    }

    public String getPresidente() {
        return presidente;
    }

    public ArrayList getReligioes() {
        return religioes;
    }

    public ArrayList getCidades() {
        return cidades;
    }

    public ArrayList getFronteiras() {
        return fronteiras;
    }

    public String getCasos_covid() {
        return casos_covid;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public void setCapital(String capital) {
        this.capital = capital;
    }

    public void setContinente(String continente) {
        this.continente = continente;
    }

    public void setBandeira(String bandeira) {
        this.bandeira = bandeira;
    }

    public void setLingua(ArrayList lingua) {
        this.lingua = lingua;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public void setHabitantes(String habitantes) {
        this.habitantes = habitantes;
    }

    public void setDensidade(String densidade) {
        this.densidade = densidade;
    }

    public void setPresidente(String presidente) {
        this.presidente = presidente;
    }

    public void setReligioes(ArrayList religioes) {
        this.religioes = religioes;
    }

    public void setCidades(ArrayList cidades) {
        this.cidades = cidades;
    }

    public void setFronteiras(ArrayList fronteiras) {
        this.fronteiras = fronteiras;
    }

    public void setCasos_covid(String casos_covid) {
        this.casos_covid = casos_covid;
    }
    
    
    
    
        
    
            
}
