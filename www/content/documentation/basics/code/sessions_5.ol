//interface.iol

include "types/Binding.iol"

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
	.studentId: string
	.examId: string
	.question: string
}

type Answer: void{
	.studentId: string
	.examId: string
	.question: string
}

type Score: void{
	.studentId: string
	.examId: string
	.score: int
}

interface StudentInterface {
	OneWay: 
		ok( Score ),
		wrong( Score )

	RequestResponse: 
		ask( Question )( Answer )
}

interface ProfessorInterface {
	OneWay: 
		requestQuestion( Exam )
		forwardAnswer( Answer )

	RequestResponse:
		receiveQuestion( void )( Question )
}

interface ExamInterface{					
	OneWay:	
		openExam( Exam ),
		join( JoinRequest ),
		ok( Score ),
		wrong( Score )
	
	RequestResponse:	
		getExams( string )( Exams )
}