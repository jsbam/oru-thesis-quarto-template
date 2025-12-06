// This is the 'typst-show.typ' file that connects Quarto metadata 
// to the ORU thesis template defined in 'typst-template.typ'

#show: doc => thesis(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
$for(by-author)$
$if(it.name.literal)$
  author: [$it.name.literal$],
$endif$
$endfor$
$elseif(author)$
  author: [$author$],
$endif$
$if(dept)$
  dept: [$dept$],
$endif$
$if(year)$
  year: [$year$],
$endif$
$if(month)$
  month: [$month$],
$endif$
$if(day)$
  day: [$day$],
$endif$
$if(committee)$
  committee: (
$for(committee)$
    (
      name: [$it.name$],
      title: [$it.title$],
    ),
$endfor$
  ),
$endif$
$if(dedication)$
  dedication: [$dedication$],
$endif$
$if(acknowledgement)$
  acknowledgement: [$acknowledgement$],
$endif$
$if(abstract)$
  abstract: [$abstract$],
$endif$
$if(keywords)$
  keywords: [$for(keywords)$$keywords$$sep$, $endfor$],
$endif$
$if(list-of-papers)$
  list-of-papers: [$list-of-papers$],
$endif$
$if(reference-section-title)$
  reference-title: [$reference-section-title$],
$endif$
  doc,
)
