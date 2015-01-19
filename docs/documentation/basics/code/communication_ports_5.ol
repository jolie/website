type mySubType: void {
	.value: double
	.comment: string
}

type myType: string {
	
	.x[ 1, * ]: mySubType

	.y[ 1, 3 ]: void {
		.value*: double
		.comment: string
	}

	.z?: void { ? }
}