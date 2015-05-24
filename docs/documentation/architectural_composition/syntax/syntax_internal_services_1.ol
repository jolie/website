interface MyInterface {
	OneWay: op1(T1)
	RequestResponse: op2(T2)(T3)
}

service SrvName {
	Interfaces: SrvIface

	init { ... }

	main {
    [ op1(x) ] { ... }
    [ op2(x)(y) { ... } ]
	}
}