let $doc := doc("paises.xml")//paisDados
let $mediaCovid := avg(for $p in $doc return number($p/casos_covid))

return
  <paisesAcimaMediaCovid>
  {
    for $p in $doc
    let $casos := number($p/casos_covid)
    where $casos > $mediaCovid
    return
      <pais nome="{$p/@nome}">
        <casos_covid>{$casos}</casos_covid>
      </pais>
  }
  </paisesAcimaMediaCovid>

