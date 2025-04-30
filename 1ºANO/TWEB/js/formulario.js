var anomat;
var preçofm;
var preçofmb;
var preçof;
var preçoi;
var km;
var idademat;


document.getElementById("submetejava").addEventListener("click",calculo);

function calculo()
{

    anomat=document.getElementById("matriculainp").value;
    preçoi=document.getElementById("preçoinp").value;
    km=document.getElementById("kminp").value;
    idademat=2023 - anomat;

    console.log(idademat);

    function quilomet(km){


        var x;
       if(1<=km<=3000)
       {
           x=1;
       }
       else
       {
           if(3000<km<=7000)
           {
               x=0.95;
           }
           else
           {
               x=0.9;
           }
       }
       return x;
       }
       
       function idade(idademat){
        var y;
       if(0<=idademat<=10)
       {
           y=idademat*0.05;
       }
       else
       {
           y=0.04*idademat;
       }
       return y;
       }
       
       var c1= quilomet(km);
       
       var c2=1-idade(idademat);

       console.log(c1,c2);
       
       preçof=preçoi*c1*c2;
       
       preçofm=preçof*0.6;
       
       preçofmb=1.1*preçof;


    document.getElementById("marcam").innerHTML=document.getElementById("marcainp").value;
    document.getElementById("modelom").innerHTML=document.getElementById("modeloinp").value;
    document.getElementById("preçom").innerHTML=document.getElementById("preçoinp").value;
    document.getElementById("matricm").innerHTML=document.getElementById("matriculainp").value;
    document.getElementById("kmm").innerHTML=document.getElementById("kminp").value;
    if(preçofm<500)
    {
        document.getElementById("preçofinalm").innerHTML="Preço muito baixo";
    }else{
    document.getElementById("preçofinalm").innerHTML=Math.round(preçofm);
    }

    

    document.getElementById("marcab").innerHTML=document.getElementById("marcainp").value;
    document.getElementById("modelob").innerHTML=document.getElementById("modeloinp").value;
    document.getElementById("preçob").innerHTML=document.getElementById("preçoinp").value;
    document.getElementById("matricb").innerHTML= document.getElementById("matriculainp").value;
    document.getElementById("kmb").innerHTML=document.getElementById("kminp").value;
    if(preçof<500)
    {
        document.getElementById("preçofinalb").innerHTML="Preço muito baixo";
    }else{
    document.getElementById("preçofinalb").innerHTML=Math.round(preçof);
    }

    document.getElementById("marcamb").innerHTML=document.getElementById("marcainp").value;
    document.getElementById("modelomb").innerHTML=document.getElementById("modeloinp").value; 
    document.getElementById("preçomb").innerHTML=document.getElementById("preçoinp").value;
    document.getElementById("matricmb").innerHTML=document.getElementById("matriculainp").value;
    document.getElementById("kmmb").innerHTML=document.getElementById("kminp").value;
    if(preçofmb<500)
    {
        document.getElementById("preçofinalmb").innerHTML="Preço muito baixo";
    }   
    else{
    document.getElementById("preçofinalmb").innerHTML= Math.round(preçofmb);
    }
}
