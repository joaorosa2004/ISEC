declare variable $lingua external;

<paises>
{
  for $p in doc("paises.xml")//paisDados
  where $p/linguas/lingua = $lingua
  return
    <pais nome="{$p/@nome}">
      <linguas>{$p/linguas}</linguas>
    </pais>
}
</paises>
