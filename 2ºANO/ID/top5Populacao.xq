<top5Populacao>
{
  for $p in subsequence(
              for $x in doc("paises.xml")//paisDados
              order by xs:integer($x/populacao) descending
              return $x,
          1, 5)
  return
    <pais>
      <nome>{ $p/@nome/string() }</nome>
      <populacao>{ $p/populacao/string() }</populacao>
    </pais>
}
</top5Populacao>
