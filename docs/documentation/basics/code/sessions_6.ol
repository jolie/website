// server.ol

include "interface.iol"

outputPort Student { Interfaces: StudentInterface }
outputPort Professor { Interfaces: ProfessorInterface }
inputPort Exam { Interfaces: ExamInterface }

cset 
{
	studentId:
		Exam.studentId
		Question.studentId
		Answer.studentId
		Score.studentId,

	examId:
		Exam.examId
		Question.examId
		Answer.examId
		Score.examId
}

main
{
	[ getExams( studentId )( global.exam.( studentId ) ) { 
		nullProcess } 
	]{ nullProcess }

	[ openExam( exam ) ] {
		Professor << exam.professor;
		global.exams.( exam.studentId ).( exam.examId ) << exam;

		join( joinRequest );
		undef( global.exam.( exam.studentId ).( exam.examId );
		Student << joinRequest.student;

		requestQuestion@Professor( exam );
		receiveQuestion@Professor( )( question );		
		ask@Student( question )( answer );
		forwardAnswer@Professor( answer );
		[ ok( score ) ] {
			ok@Student()
		}
		[ wrong( score ) ] {
			wrong@Student()
		}
	}
}
