{**
 * templates/frontend/pages/userLostPassword.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2000-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * Password reset form.
 *
 *}
{include file="frontend/components/header.tpl" pageTitle="user.login.resetPassword"}

<div id="main-content" class="page page_lost_password">

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
			<h2 class="card-title">{translate key="user.login.resetPassword"}</h2>
			<p class="card-subtitle">{translate key="user.login.resetPasswordInstructions"}</p>

			{if $error}
				<div class="alert alert-danger py-2 px-3 mb-3 font-size-13" role="alert">
					{translate key=$error}
				</div>
			{/if}

			<form class="pkp_form lost_password" id="lostPasswordForm" action="{url page="login" op="requestResetPassword"}" method="post">
				{csrf}

				<div class="form-group mb-4">
					<label for="login-email">
						{translate key="user.login.registeredEmail"}
					</label>
					<input type="email" name="email" class="form-control" id="login-email" placeholder="{translate key='user.login.registeredEmail'}" value="{$email|escape}" maxlength="32" required>
				</div>

				<div class="buttons text-center mt-4">
					<button type="submit" class="btn-primary-custom mb-3">
						{translate key="user.login.resetPassword"}
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
