// This partial overrides Pandoc's default bibliography generation
// to include the custom title parameter

$if(bibliography)$
$if(csl)$
#set bibliography(style: "$csl$", title: [$reference-section-title$])
$else$
#set bibliography(title: [$reference-section-title$])
$endif$

#bibliography("$for(bibliography)$$bibliography$$sep$", "$endfor$")
$endif$
