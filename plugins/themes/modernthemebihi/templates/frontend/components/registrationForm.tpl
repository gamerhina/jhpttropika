{**
 * templates/frontend/components/registrationForm.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the basic registration form fields
 *
 * @uses $locale string Locale key to use in the affiliate field
 * @uses $firstName string First name input entry if available
 * @uses $middleName string Middle name input entry if available
 * @uses $lastName string Last name input entry if available
 * @uses $countries array List of country options
 * @uses $country string The selected country if available
 * @uses $email string Email input entry if available
 * @uses $username string Username input entry if available
 *}
<div class="row">
	<div class="col-md-6 col-12 mb-3">
		<fieldset class="identity">
			<legend>
				{translate key="user.profile"}
			</legend>
			<div class="fields">
				<div class="form-group mb-2 given_name">
					<label for="givenName">
						{translate key="user.givenName"}			
						<span class="form-control-required">*</span>
					</label>
					<input class="form-control" type="text" name="givenName" id="givenName" value="{$givenName|escape}" maxlength="255" required>
				</div>
				<div class="form-group mb-2 family_name">
					<label for="familyName">
						{translate key="user.familyName"}
						<span class="form-control-required">*</span>
					</label>
					<input class="form-control" type="text" name="familyName" id="familyName" value="{$familyName|escape}" maxlength="255" required>
				</div>
				<div class="form-group mb-2 affiliation">
					<label for="affiliation">
						{translate key="user.affiliation"}
						<span class="form-control-required">*</span>
					</label>
					<input class="form-control" type="text" name="affiliation[{$primaryLocale|escape}]" id="affiliation" value="{$affiliation.$primaryLocale|escape}" required>
				</div>
				<div class="form-group mb-2 country">
					<label for="country">
						{translate key="common.country"}
						<span class="form-control-required">*</span>
					</label>
					<select class="form-control" name="country" id="country" required>
						<option></option>
						{html_options options=$countries selected=$country}
					</select>
				</div>
			</div>
		</fieldset>
	</div>
	<div class="col-md-6 col-12 mb-3">
		<fieldset class="login">
			<legend>
				{translate key="user.login"}
			</legend>
			<div class="fields">
				<div class="form-group mb-2 email">
					<label for="email">
						{translate key="user.email"}
						<span class="form-control-required">*</span>
					</label>
					<input class="form-control" type="email" name="email" id="email" value="{$email|escape}" maxlength="90" required>
				</div>
				<div class="form-group mb-2 username">
					<label for="username">
						{translate key="user.username"}
						<span class="form-control-required">*</span>
					</label>
					<input class="form-control" type="text" name="username" id="username" value="{$username|escape}" maxlength="32" required>
				</div>
				<div class="form-group mb-2 password">
					<label for="password">
						{translate key="user.password"}
						<span class="form-control-required">*</span>
					</label>
					<input class="form-control" type="password" name="password" id="password" password="true" maxlength="32" required>
				</div>
				<div class="form-group mb-2 password">
					<label for="password2">
						{translate key="user.repeatPassword"}
						<span class="form-control-required">*</span>
					</label>
					<input class="form-control" type="password" name="password2" id="password2" password="true" maxlength="32" required>
				</div>
			</div>
		</fieldset>
	</div>
</div>
