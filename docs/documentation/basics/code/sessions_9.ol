outputPort Student { ... }
outputPort Professor { ... }
inputPort Exam { ... }

cset {
	studentId: 	Exam.studentId
				Question.studentId
				Answer.studentId
				Score.studentId,

	examId: Exam.examId
			Question.examId
			Answer.examId
			Score.examId
}

main
{
	[ getExams( studentId )( global.(studentId) ) { nullProcess } ]
	{ nullProcess }

	[ openExam( exam ) ] {
		Professor << exam.Professor;
		global.(exam.studentId).(exam.examId) << exam;

		join( joinRequest )() {
			undef( global.(exam.studentId).(exam.examId) );
			Student << joinRequest.Student
		};

		requestQuestion@Professor( exam );
		receiveQuestion( question );		
		ask@Student( question )( answer );
		//checkAnswer@Professor( answer )( score );
		forwardAnswer@Professor( answer );
		[ ok( score ) ] {
			ok@Student()
		}
		[ wrong( score ) ] {
			wrong@Student()
		}
	}
}
