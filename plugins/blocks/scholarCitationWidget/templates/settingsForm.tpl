{**
 * plugins/generic/scholarCitationWidget/templates/settingsForm.tpl
 *
 * Copyright (c) 2026 Bihikmi
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * Settings Form for Scholar Citation Widget
 *}
<script>
	$(function() {ldelim}
		$('#scholarCitationWidgetSettingsForm').pkpHandler('$.pkp.controllers.form.AjaxFormHandler');

		$('#syncNowButton').click(function(e) {ldelim}
			e.preventDefault();
			var scholarId = $('#scholarId').val();
			var jsonPath = $('#jsonFileLocation').val();
			if (!scholarId) {ldelim}
				alert('Scholar ID is required');
				return;
			{rdelim}
			
			var $btn = $(this);
			var originalText = $btn.text();
			$btn.attr('disabled', true).text('Syncing...');
			
			$.post('{url router=\PKP\core\PKPApplication::ROUTE_COMPONENT component="grid.settings.plugins.SettingsPluginGridHandler" op="manage" category="blocks" plugin=$pluginName verb="sync"}', {ldelim}
				scholarId: scholarId,
				jsonPath: jsonPath,
				csrfToken: $('input[name="csrfToken"]').val()
			{rdelim}, function(data) {ldelim}
				if (data.status) {ldelim}
					alert(data.content || 'Sync successful');
				{rdelim} else {ldelim}
					alert(data.content || 'Sync failed');
				{rdelim}
				$btn.attr('disabled', false).text(originalText);
			{rdelim}, 'json').fail(function() {ldelim}
				alert('Sync failed. Please check server logs.');
				$btn.attr('disabled', false).text(originalText);
			{rdelim});
		{rdelim});
	{rdelim});
</script>

<form class="pkp_form" id="scholarCitationWidgetSettingsForm" method="post" action="{url router=\PKP\core\PKPApplication::ROUTE_COMPONENT component="grid.settings.plugins.SettingsPluginGridHandler" op="manage" category="blocks" plugin=$pluginName verb="settings" save=true}">
	{csrf}
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="scholarCitationWidgetSettingsFormNotification"}

	{fbvFormArea id="scholarSettingsArea"}
		{fbvFormSection}
			{fbvElement type="text" id="scholarId" value=$scholarId label="plugins.block.scholarCitationWidget.settings.scholarId" required="true"}
			<button type="button" id="syncNowButton" class="pkp_button pkp_button_action" style="margin-top: 10px;">Sync Now</button>
		{/fbvFormSection}
		{fbvFormSection}
			{fbvElement type="text" id="sidebarTitle" value=$sidebarTitle label="plugins.block.scholarCitationWidget.settings.sidebarTitle"}
		{/fbvFormSection}
		{fbvFormSection}
			{fbvElement type="text" id="cacheHours" value=$cacheHours label="plugins.block.scholarCitationWidget.settings.cacheHours"}
		{/fbvFormSection}
		{fbvFormSection}
			{fbvElement type="text" id="jsonFileLocation" value=$jsonFileLocation label="plugins.block.scholarCitationWidget.settings.jsonFileLocation" description="plugins.block.scholarCitationWidget.settings.jsonFileLocationDesc"}
		{/fbvFormSection}
		{fbvFormSection}
			{fbvElement type="text" id="themeColor" value=$themeColor label="plugins.block.scholarCitationWidget.settings.themeColor"}
		{/fbvFormSection}
		{fbvFormSection list="true"}
			{fbvElement type="checkbox" id="showButton" value="1" checked=$showButton label="plugins.block.scholarCitationWidget.settings.showButton"}
		{/fbvFormSection}
		{fbvFormSection list="true"}
			{fbvElement type="checkbox" id="showGraph" value="1" checked=$showGraph label="plugins.block.scholarCitationWidget.settings.showGraph"}
		{/fbvFormSection}
	{/fbvFormArea}

	{fbvFormButtons}

	<p><span class="formRequired">{translate key="common.requiredField"}</span></p>
</form>
