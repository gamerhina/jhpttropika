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
	{rdelim});
</script>

<form class="pkp_form" id="scholarCitationWidgetSettingsForm" method="post" action="{url router=\PKP\core\PKPApplication::ROUTE_COMPONENT component="grid.settings.plugins.SettingsPluginGridHandler" op="manage" category="blocks" plugin=$pluginName verb="settings" save=true}">
	{csrf}
	{include file="controllers/notification/inPlaceNotification.tpl" notificationId="scholarCitationWidgetSettingsFormNotification"}

	{fbvFormArea id="scholarSettingsArea"}
		{fbvFormSection}
			{fbvElement type="text" id="scholarId" value=$scholarId label="plugins.block.scholarCitationWidget.settings.scholarId" required="true"}
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
