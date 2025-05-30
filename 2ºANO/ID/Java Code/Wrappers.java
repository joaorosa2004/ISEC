/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mycompany.trabalhopraticoid_joaorosa;

import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *
 * @author joaor
 */
//--------------------------------------WrapperDB---------------------------------
public class Wrappers {

    public static String obtem_continente(String pais) throws IOException {
        String link = "https://pt.db-city.com/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;
        String er = "<th>Continente</th>\\s*<td>\\s*<a[^>]*>([^<]+)</a>";
        Pattern p = Pattern.compile(er);
        Matcher m;
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m = p.matcher(linha);
            while (m.find()) {
                ler.close();
                String continenteLimpo = m.group(1).replaceAll("<.*?>", "").trim();
                return continenteLimpo;
            }
        }
        ler.close();
        return null;
    }

    public static ArrayList<String> obtem_linguas(String pais) throws IOException {
        String link = "https://pt.db-city.com/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;

        String er = "<th>Língua oficial</th><td>(.*?)</td>";
        Pattern p = Pattern.compile(er);
        Matcher m;
        ArrayList lista = new ArrayList();
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m = p.matcher(linha);
            while (m.find()) {

                String linguasRaw = m.group(1); // Ex: "Inglês<br/>Hindi"
                String[] linguasSeparadas = linguasRaw.split("<br\\s*/?>"); // Dividir corretamente
                for (String lingua : linguasSeparadas) {
                    lista.add(lingua.trim()); // Tirar espaços antes/depois e adicionar à lista
                }

            }
        }
        ler.close();
        return lista;
    }

    public static String obtem_area(String pais) throws IOException {
        String link = "https://pt.db-city.com/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;
        String er = "<th><a href=\"/País--Superfície\".*?</a></th><td>([\\d\\.,]+)\\s*km²</td>";
        Pattern p = Pattern.compile(er);
        Matcher m;
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m = p.matcher(linha);
            while (m.find()) {
                ler.close();

                return m.group(1).replaceAll("\\.", "");
            }
        }
        ler.close();
        return null;

    }

    public static String obtem_habitantes(String pais) throws IOException {
        String link = "https://pt.db-city.com/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;
        String er = "<th><a href=\"/País--Número-de-habitantes\".*?</a></th><td>([\\d\\.,]+)\\s*habitantes";
        Pattern p = Pattern.compile(er);
        Matcher m;
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m = p.matcher(linha);
            while (m.find()) {
                ler.close();

                return m.group(1).replaceAll("\\.", "");
            }
        }
        ler.close();
        return null;
    }

    public static String obtem_densidade(String pais) throws IOException {
        String link = "https://pt.db-city.com/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;
        String er = "<th><a href=\"/País--Densidade-populacional\".*?</a></th><td>\\s*([\\d\\.,]+)\\s*/km²";
        Pattern p = Pattern.compile(er);
        Matcher m;
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m = p.matcher(linha);
            while (m.find()) {
                ler.close();

                return m.group(1).replaceAll(",", "\\.");
            }
        }
        ler.close();
        return null;
    }

    public static ArrayList<String> obtem_religiao(String pais) throws IOException {
        String link = "https://pt.db-city.com/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;

        String er = "<li><strong>(.*?)</strong>";

        Pattern p = Pattern.compile(er);
        Matcher m;
        ArrayList lista = new ArrayList();
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m = p.matcher(linha);
            while (m.find()) {

                lista.add(m.group(1));

            }
        }
        ler.close();
        return lista;
    }

    public static ArrayList<String> obtem_cidades(String pais) throws IOException {
        String link = "https://pt.db-city.com/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;

        String er = "Cidades importantes\\s*:\\s*([^\\.]+)";

        Pattern p = Pattern.compile(er);
        Matcher m;
        ArrayList lista = new ArrayList();
        while (ler.hasNextLine()) {
            linha = ler.nextLine();
            m = p.matcher(linha);

            if (m.find()) {
                String cidadesRaw = m.group(1);
                cidadesRaw = cidadesRaw.replaceAll("\\s+e\\s+", ", ");
                String[] cidadesSeparadas = cidadesRaw.split("\\s*,\\s*");

                for (String cidade : cidadesSeparadas) {
                    lista.add(cidade.trim());
                }
            }
        }
        ler.close();
        return lista;
    }

    public static ArrayList<String> obtem_fronteiras(String pais) throws IOException {
        String link = "https://pt.db-city.com/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;

        String er = "<a href=\"/[^\"]+\" title=\"([A-Za-zÁÉÍÓÚáéíóúÂÊÔâêôÀàÜüÇçÃÕãõ\\s]+)\"><img[^>]*>[^<]+</a>";
        //"<a href=\"/[^\"]+\" title=\"([A-Za-zÁÉÍÓÚáéíóúÂÊÔâêôÀàÜüÇçÃÕãõ]+)\"><img"
        //">Fronteira\\s*.+>\\s*"+pais+"\\s*<.+>\\s*([A-Za-zÁÉÍÓÚáéíóúÂÊÔâêôÀàÜüÇçÃÕãõ\\\\s]+)</a>"
        //"<a href=\"/[^\"]+\" title=\"([A-Za-zÁÉÍÓÚáéíóúÂÊÔâêôÀàÜüÇçÃÕãõ]+)\">"

        Pattern p = Pattern.compile(er);
        Matcher m;
        ArrayList lista = new ArrayList();
        while (ler.hasNextLine()) {
            linha = ler.nextLine();
            m = p.matcher(linha);

            while (m.find()) {

                String nomePais = m.group(1).trim();

                // Filtrar "Bandeira.....
                if (!nomePais.equalsIgnoreCase("Bandeira " + pais)) {
                    lista.add(nomePais);
                }

            }
        }
        ler.close();
        return lista;
    }

    public static String obtem_covid(String pais) throws IOException {
        String link = "https://pt.db-city.com/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;
        String er = "<th>Confirmado</th><td>([.0-9]+)</td>";
        Pattern p = Pattern.compile(er);
        Matcher m;
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m = p.matcher(linha);
            while (m.find()) {
                ler.close();

                return m.group(1).replaceAll("\\.", "");
            }
        }
        ler.close();
        return null;
    }

    //--------------------------------------WrapperWiki---------------------------------
    public static String obtem_capital(String pais) throws IOException {
        String link = "https://pt.wikipedia.org/wiki/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;
        String er1 = ">Capital<";
        String er2 = ">([A-Za-zÁÉÍÓÚáéíóúÂÊÔâêôÀàÜüÇçÃÕãõ\\s]+)</a>";
        Pattern p1 = Pattern.compile(er1);
        Pattern p2 = Pattern.compile(er2);
        Matcher m1, m2;
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m1 = p1.matcher(linha);
            while (m1.find()) {
                ler.nextLine(); //Saltar linha lixo
                linha = ler.nextLine();
                m2 = p2.matcher(linha);
                if (m2.find()) {
                    ler.close();
                    return m2.group(1);
                }

            }
        }
        ler.close();
        return null;
    }

    public static String obtem_bandeira(String pais) throws IOException {
        String link = "https://pt.wikipedia.org/wiki/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;
        String er = "<img alt=\"[A-Za-zÁÉÍÓÚáéíóúÂÊÔâêôÀàÜüÇçÃÕãõ\\s]+\" src=\"([^\"]+)\" decoding";
        //<img alt="Bandeira de Portugal" src="//upload.wikimedia.org/wikipedia/commons/thumb/a/ad/Flag_of_Portugal_%28alternate%29.svg/125px-Flag_of_Portugal_%28alternate%29.svg.png" decoding
        Pattern p = Pattern.compile(er);
        Matcher m;
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m = p.matcher(linha);
            while (m.find()) {
                ler.close();
                return m.group(1);
            }
        }
        ler.close();
        return null;
    }

    public static String obtem_presidente(String pais) throws IOException {
        String link = "https://pt.wikipedia.org/wiki/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;
        //>Presidente<|>Rei<
        //<td scope="row" style="vertical-align:
        String er1 = ">Presidente<|>Rei<|>Monarca<|>Imperador<|>Emir<";
        String er2 = "title=\"[A-Za-zÁÉÍÓÚáéíóúÂÊÔâêôÀàÜüğÇçÃÕãõ\\s]+\">([A-Za-zÁÉÍÓÚáéíóúÂÊÔâêôÀàÜğüÇçÃÕãõ\\s]+)<";
        Pattern p1 = Pattern.compile(er1);
        Pattern p2 = Pattern.compile(er2);
        Matcher m1, m2;
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m1 = p1.matcher(linha);
            while (m1.find()) {
                ler.nextLine(); //Saltar linha lixo
                linha = ler.nextLine();
                m2 = p2.matcher(linha);
                if (m2.find()) {
                    ler.close();
                    return m2.group(1);
                }

            }
        }
        ler.close();
        return null;

    }

    /*public static ArrayList<String> obtem_fronteiras(String pais) throws IOException {
        String link = "https://pt.wikipedia.org/wiki/";
        HttpRequestFunctions.httpRequest1(link, pais, "pais.html");
        Scanner ler = new Scanner(new FileInputStream("pais.html"));
        String linha;
        String er1 = ">Fronteira<";
        String er2 = ">([A-Za-zÁÉÍÓÚáéíóúÂÊÔâêôÀàÜüÇçÃÕãõ\\s]+)</a>";
        Pattern p1 = Pattern.compile(er1);
        Pattern p2 = Pattern.compile(er2);
        Matcher m1, m2;
        ArrayList lista = new ArrayList();
        while ((ler.hasNextLine())) {
            linha = ler.nextLine();
            m1 = p1.matcher(linha);
            while (m1.find()) {
                ler.nextLine(); //Saltar linha lixo
                linha = ler.nextLine();
                m2 = p2.matcher(linha);
                while (m2.find()) {

                    lista.add(m2.group(1));

                }

            }

        }
        ler.close();
        return lista;
    }*/
    public static Pais criaPais(String pais) throws IOException {
        Pais x;
        System.out.println("\t\n----Dados retirados de WIKIPEDIA e db-city----\n\t");

        String capital = Wrappers.obtem_capital(pais); //wikipedia
        System.out.println("Capital: " + capital);

        String continente = Wrappers.obtem_continente(pais);
        System.out.println("Continente: " + continente); //db-city

        String bandeira = Wrappers.obtem_bandeira(pais); //wikipedia
        System.out.println("Link Bandeira: " + bandeira);

        ArrayList linguas = Wrappers.obtem_linguas(pais); //db-city
        System.out.println("Linguas Oficiais: " + linguas);

        String area = Wrappers.obtem_area(pais); //db-city
        System.out.println("Area: " + area);

        String habitantes = Wrappers.obtem_habitantes(pais);//db-city
        System.out.println("População: " + habitantes);

        String densidade = Wrappers.obtem_densidade(pais);//db-city
        System.out.println("Densidade: " + densidade);

        String presidente = Wrappers.obtem_presidente(pais);//Wikipedia
        System.out.println("Chefe de estado: " + presidente);

        ArrayList religioes = Wrappers.obtem_religiao(pais);
        System.out.println("Religiões: " + religioes); //db-city

        ArrayList cidades = Wrappers.obtem_cidades(pais);
        System.out.println("Cidades Importantes: " + cidades); //db-city

        ArrayList fronteiras = Wrappers.obtem_fronteiras(pais);
        System.out.println("Países fronteira: " + fronteiras);//db-city

        String covid = Wrappers.obtem_covid(pais);
        System.out.println("Casos covid: " + covid); //db-city

        x = new Pais(pais, capital, continente, bandeira, linguas, area, habitantes, densidade, presidente, religioes, cidades, fronteiras, covid);
        return x;
    }
}
