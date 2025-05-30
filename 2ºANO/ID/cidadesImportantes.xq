declare variable $nomePais external;

string-join(
  for $cidade in doc("paises.xml")//paisDados[@nome = $nomePais]/cidades_importantes/cidade
  return data($cidade),
  '&#10;'
)
