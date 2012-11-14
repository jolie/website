// server.ol

outputPort Student { ... }
outputPort Professor { ... }
inputPort Exam { ... }

cset {
	studentId: Exam.studentId, Question.studentId, Answer.studentId, Score.studentId 
	examId: Exam.examId, Question.examId, Answer.examId, Score.examId
}

main
{
	[ getExams( studentId )( global.(studentId) ) { nullProcess } ]
	{ nullProcess }

	[ openExam( exam ) ] {
		Professor << exam.professor;
		global.(exam.studentId).(exam.examId) << exam;

		join( joinRequest )() {
			undef( global.(exam.studentId).(exam.examId) );
			Student << joinRequest.student
		};

		requestQuestion@Professor( exam );
		receiveQuestion( question );		
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
