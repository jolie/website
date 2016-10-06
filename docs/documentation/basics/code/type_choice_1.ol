//choice between native types
type numeric: int | long

//choice with linked types
type linked: numeric | void

//choice with subtypes
type subtypes: void {.id: string | int}

//nested choices
type nested: linked | subtypes | void
