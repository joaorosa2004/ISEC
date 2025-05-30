/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */
package com.mycompany.trabalhopraticoid_joaorosa;

import java.awt.Frame;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.ArrayList;
import java.util.Scanner;
import org.jdom2.Document;

/**
 *
 * @author joaor
 */
public class TrabalhoPraticoID_JoaoRosa {

    public static void main(String[] args) throws IOException {
        JFramePaises app = new JFramePaises();
        app.setVisible(true);
        //String pais = "Espanha";
        //Pais x = Wrappers.criaPais(pais);
        Document doc = XMLJDomFunctions.lerDocumentoXML("paises.xml");
        //doc = ModeloXML.adicionaPais(x, doc);
        //doc = ModeloXML.removePais(pais, doc);
        //doc = ModeloXML.removeATRIBUTO(pais, "ATRIBUTO", doc);
        if(doc!=null){
            XMLJDomFunctions.escreverDocumentoParaFicheiro(doc, "paises.xml");
        }
        
    }
    
    //Função para conseguir Validar DTD e XSD
    public static void copiarFicheiro(String origem, String destino) throws IOException {
        Files.copy(Paths.get(origem), Paths.get(destino), StandardCopyOption.REPLACE_EXISTING);
    }
    
    static String ler_ficheiro(String nomeF) throws FileNotFoundException {
        String linha;
        Scanner input = new Scanner(new FileInputStream(nomeF));
        StringBuilder texto = new StringBuilder();
        while (input.hasNextLine()) {
            linha = input.nextLine();
            texto.append(linha).append("\n");
        }
        input.close();
        return texto.toString();
    }
}
