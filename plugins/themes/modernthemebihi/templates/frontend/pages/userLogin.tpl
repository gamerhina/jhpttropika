{**
 * templates/frontend/pages/userLogin.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2000-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * User login form.
 *
 *}
{include file="frontend/components/header.tpl" pageTitle="user.login"}

<div id="main-content" class="page page_login">

	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="user.login"}

	<div class="auth-page-container">
		<div class="login-card">
			{assign var="favicon" value=$currentContext->getLocalizedFavicon()}
			{if $favicon}
				<div class="text-center mb-4">
					<a href="{$homeUrl}">
						<img src="{$publicFilesDir}/{$favicon.uploadName|escape:"url"}" alt="Favicon" style="max-height: 60px; max-width: 60px; object-fit: contain;">
					</a>
				</div>
			{/if}
			<h2 class="card-title">{translate key="user.login"}</h2>
			<p class="card-subtitle">{translate key="plugins.themes.modernthemebihi.login.subtitle"}</p>

			{if $loginMessage}
				<div class="alert alert-info py-2 px-3 mb-3 font-size-13" role="alert">
					{translate key=$loginMessage}
				</div>
			{/if}

			{if $error}
				<div class="alert alert-danger py-2 px-3 mb-3 font-size-13" role="alert">
					{translate key=$error reason=$reason}
				</div>
			{/if}

			<form class="pkp_form login" id="login" method="post" action="{$loginUrl}">
				{csrf}
				<input type="hidden" name="source" value="{$source|strip_unsafe_html|escape}" />

				<div class="form-group mb-3">
					<label for="login-username">
						{translate key="user.username"}
					</label>
					<input type="text" name="username" class="form-control" id="login-username" placeholder="{translate key='user.username'}" value="{$username|escape}" maxlength="32" required>
				</div>

				<div class="form-group mb-3">
					<label for="login-password">
						{translate key="user.password"}
					</label>
					<input type="password" name="password" class="form-control" id="login-password" placeholder="{translate key='user.password'}" password="true" maxlength="32" required="$passwordRequired">
				</div>

				<div class="d-flex justify-content-between align-items-center mb-3">
					<div class="form-check mb-0">
						<label class="form-check-label font-size-13 mb-0" style="font-weight: normal; cursor: pointer;">
							<input type="checkbox" name="remember" class="form-check-input" id="remember" value="1" checked="$remember"> {translate key="user.login.rememberUsernameAndPassword"}
						</label>
					</div>
				</div>
				<div class="text-center mb-3">
					<a href="{url page="login" op="lostPassword"}" class="font-size-13">
						{translate key="user.login.forgotPassword"}
					</a>
				</div>

				<div class="buttons text-center mt-4">
					<button type="submit" class="btn-primary-custom mb-3">
						{translate key="user.login"}
					</button>

					{if !$disableUserReg}
						{capture assign="registerUrl"}{url page="user" op="register" source=$source}{/capture}
						<a class="btn-secondary-custom" href="{$registerUrl}">
							{translate key="user.login.registerNewAccount"}
						</a>
					{/if}
				</div>
			</form>
		</div>
	</div>
</div><!-- .page -->

{include file="frontend/components/footer.tpl"}

