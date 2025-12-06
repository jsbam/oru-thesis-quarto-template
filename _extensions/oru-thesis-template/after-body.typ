// This partial overrides Pandoc's default bibliography generation
// to include the custom title parameter

#set bibliography(style: "$csl$", title: [$reference-section-title$])

#bibliography("$for(bibliography)$$bibliography$$sep$", "$endfor$")
