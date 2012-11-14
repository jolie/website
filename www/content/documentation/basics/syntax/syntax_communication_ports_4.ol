T_def ::= type id T
	T ::= : BT [ { .id_1 R_1 T_1 ... id_n R_n T_n } ] | undefined
	R ::= [ min, max ] | * | ?
	BT::= string | int | long | double | bool | raw | void | any