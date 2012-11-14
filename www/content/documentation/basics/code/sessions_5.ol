//interface.ol

type Exam: void {
	.professor: Binding
	.studentId: string
	.examId: string
}

type Exams: void {
	.exam*: Exam
}

type JoinRequest: void {
	.student: Binding
}

type Question: void{
	.studentId: string,
	.examId: string,
	.question: string
}

type Answer: void{
	.studentId: string,
	.examId: string,
	.question: string
}

type Score: void{
	.studentId: string
	.examId: string
	.score: int
}

interface ExamInterface{
	RequestResponse:	getExams( string )( Exams ),
						ask( Question )( Answer )
						
	OneWay:	openExam( Exam ),
			join( joinRequest )
			requestQuestion( Exam ),
			receiveQuestion( Question ),
			forwardAnswer( Answer ),
			ok( Score ),
			wrong( Score )
}