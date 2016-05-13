interface IfaceName {
 RequestResponse:
	Op1( ReqType1 )( ResType1 ) throws ErrX( MsgTypeX ) ... ErrY( MsgTypeY ) 
  //...
  OpN( ReqTypeN )( ResTypeN ) throws ErrW( MsgTypeW ) ... ErrZ( MsgTypeZ )
}