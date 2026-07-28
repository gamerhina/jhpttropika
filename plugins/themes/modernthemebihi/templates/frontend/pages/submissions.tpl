{**
 * templates/frontend/pages/submissions.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view the editorial team.
 *
 * @uses $currentJournal Journal The current journal
 * @uses $submissionChecklist array List of requirements for submissions
 *}
{include file="frontend/components/header.tpl" pageTitle="about.submissions"}

<div id="main-content" class="page page_submissions">

	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.submissions"}

	{* Page Title *}
	<div class="page-header mb-4">
		<h1 class="font-size-27">{translate key="about.submissions"}</h1>
	</div>
	{* /Page Title *}

	{* Login/register prompt wrapped in a sleek CTA card *}
	<div class="submissions-cta-card shadow-sm">
		<h2>{translate key="about.onlineSubmissions"}</h2>
		{if $isUserLoggedIn}
			{capture assign="newSubmission"}<a href="{url page="submission" op="wizard"}" class="btn btn-success px-4 py-2 mx-1 my-1" style="border-radius: 6px; font-weight: 600;">{translate key="about.onlineSubmissions.newSubmission"}</a>{/capture}
			{capture assign="viewSubmissions"}<a href="{url page="submissions"}" class="btn btn-outline-success px-4 py-2 mx-1 my-1" style="border-radius: 6px; font-weight: 600;">{translate key="about.onlineSubmissions.viewSubmissions"}</a>{/capture}
			<p class="mb-0 mt-3 font-size-14 text-dark">{translate key="about.onlineSubmissions.submissionActions" newSubmission=$newSubmission viewSubmissions=$viewSubmissions}</p>
		{else}
			{capture assign="login"}<a href="{url page="login"}" class="btn btn-success px-4 py-2 mx-1 my-1" style="border-radius: 6px; font-weight: 600;">{translate key="about.onlineSubmissions.login"}</a>{/capture}
			{capture assign="register"}<a href="{url page="user" op="register"}" class="btn btn-outline-success px-4 py-2 mx-1 my-1" style="border-radius: 6px; font-weight: 600;">{translate key="about.onlineSubmissions.register"}</a>{/capture}
			<p class="mb-0 mt-3 font-size-14 text-dark">{translate key="about.onlineSubmissions.registrationRequired" login=$login register=$register}</p>
		{/if}
	</div>

	{* Submission Checklist *}
	{if $submissionChecklist}
		<div class="submission-card shadow-sm">
			<h3 class="page-body-header d-flex justify-content-between align-items-center">
				<span>
					<span class="glyphicon glyphicon-check" aria-hidden="true" style="color: var(--bg-theme); margin-right: 8px;"></span>
					{translate key="about.submissionPreparationChecklist"}
				</span>
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission" sectionTitleKey="about.submissionPreparationChecklist"}
			</h3>
			<p class="lead description font-size-14 text-muted mb-4">
				{translate key="about.submissionPreparationChecklist.description"}
			</p>
			<ul class="list-group list-group-flush">
				{foreach from=$submissionChecklist item=checklistItem}
					<li class="list-group-item d-flex align-items-start border-0 py-3" style="padding-left: 0; padding-right: 0;">
						<span class="glyphicon glyphicon-ok-circle text-success" aria-hidden="true" style="margin-right: 12px; margin-top: 3px; font-size: 1.1rem;"></span>
						<span class="item-content font-size-14">{$checklistItem.content|nl2br}</span>
					</li>
				{/foreach}
			</ul>
		</div>
	{/if}
	{* /Submission Checklist *}

	{* Author Guidelines *}
	{if $currentJournal->getLocalizedData('authorGuidelines')}
		<div class="submission-card shadow-sm">
			<h3 class="page-body-header d-flex justify-content-between align-items-center">
				<span>
					<span class="glyphicon glyphicon-info-sign" aria-hidden="true" style="color: var(--bg-theme); margin-right: 8px;"></span>
					{translate key="about.authorGuidelines"}
				</span>
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="workflow" anchor="submission" sectionTitleKey="about.authorGuidelines"}
			</h3>
			<div class="guidelines-content font-size-14 text-justify">
				{$currentJournal->getLocalizedData('authorGuidelines')}
			</div>
		</div>
	{/if}
	{* /Author Guidelines *}

	{* Copyright Notice *}
	{if $currentJournal->getLocalizedData('copyrightNotice')}
		<div class="submission-card shadow-sm">
			<h3 class="page-body-header d-flex justify-content-between align-items-center">
				<span>
					<span class="glyphicon glyphicon-copyright-mark" aria-hidden="true" style="color: var(--bg-theme); margin-right: 8px;"></span>
					{translate key="about.copyrightNotice"}
				</span>
				{include file="frontend/components/editLink.tpl" page="management" op="settings" path="distribution" anchor="license" sectionTitleKey="about.copyrightNotice"}
			</h3>
			<div class="copyright-content font-size-14 text-justify">
				{$currentJournal->getLocalizedData('copyrightNotice')}
			</div>
		</div>
	{/if}
	{* /Copyright Notice *}

</div><!-- .page -->

{include file="common/frontend/footer.tpl"}
