constants {
	Location_AccountManager = "socket://localhost:9005"
}

type CheckUserKeyType:void {
	.username:string
	.key:string
}

type CheckUserPasswordType:void {
	.username:string
	.password:string
}

type CreateFreshPasswordType:void {
	.username:string
}

type ChangePasswordType:void {
	.username:string
	.password:string
	.newPassword:string
}

type CreateUserType:void {
	.username:string
	.password:string
}

type UpdateFreshKeyType:void {
	.username:string
	.password:string
}

interface AccountManagerInterface {
RequestResponse:
	checkUserPassword(CheckUserPasswordType)(void) throws AuthenticationFailed(string),
	checkUserKey(CheckUserKeyType)(void) throws AuthenticationFailed(string),
	createUser(CreateUserType)(void) throws InvalidUsername(string),
	createFreshPassword(ChangePasswordType)(string) throws InvalidUsername(string),
	changePassword(ChangePasswordType)(void) throws AuthenticationFailed(string),
	updateFreshKey(UpdateFreshKeyType)(string) throws AuthenticationFailed(string),
	existsUser(string)(bool)
}

outputPort AccountManager {
Location: Location_AccountManager
Protocol: sodep
Interfaces: AccountManagerInterface
}