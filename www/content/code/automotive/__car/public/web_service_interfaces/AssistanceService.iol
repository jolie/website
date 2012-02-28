type getOrchestrator:void {
        .coord:string
        .car_model:string
        .fault:string
}

type getOrchestratorResponse:void {
        .code:string
}

interface Assistance {
RequestResponse:
        getOrchestrator(getOrchestrator)(getOrchestratorResponse)
}

outputPort AssistanceServicePort {
Location: "socket://localhost:2001"
Protocol: soap {
        .wsdl = "./public/web_service_interfaces/Assinstance.wsdl";
        .wsdl.port = "AssistanceServicePort"
}
Interfaces: Assistance
}

