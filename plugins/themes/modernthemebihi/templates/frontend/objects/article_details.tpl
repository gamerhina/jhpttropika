{**
 * templates/frontend/objects/article_details.tpl
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2003-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article which displays all details about the article.
 *}
{if !$heading}
	{assign var="heading" value="h3"}
{/if}
<article class="obj_article_details">

	{* Indicate if this is only a preview *}
	{if $publication->getData('status') !== \PKP\submission\PKPSubmission::STATUS_PUBLISHED}
	<div class="cmp_notification notice">
		{capture assign="submissionUrl"}{url page="workflow" op="access" path=$article->getId()}{/capture}
		{translate key="submission.viewingPreview" url=$submissionUrl}
	</div>
	{* Notification that this is an old version *}
	{elseif $currentPublication->getId() !== $publication->getId()}
		<div class="cmp_notification notice">
			{capture assign="latestVersionUrl"}{url page="article" op="view" path=$article->getBestId()}{/capture}
			{translate key="submission.outdatedVersion"
				datePublished=$publication->getData('datePublished')|date_format:$dateFormatShort
				urlRecentVersion=$latestVersionUrl|escape
			}
		</div>
	{/if}

	<h1 class="page_title">
		{$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
	</h1>

	{if $publication->getLocalizedData('subtitle')}
		<h2 class="subtitle">
			{$publication->getLocalizedSubTitle(null, 'html')|strip_unsafe_html}
		</h2>
	{/if}

	<div class="row article-details-wrapper mt-3">
		{* LEFT COLUMN: Cover, Galleys/PDF, Date, DOI, Keywords *}
		<div class="col-12 col-md-3 col-lg-3 article-sidebar-left">
			<div class="article-sidebar-box p-3 mb-3 rounded border bg-light">
				{* Article/Issue cover image *}
				{if $publication->getLocalizedData('coverImage') || ($issue && $issue->getLocalizedCoverImage())}
					<div class="item cover_image mb-3 text-center">
						{if $publication->getLocalizedData('coverImage')}
							{assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
							<img class="img-fluid rounded shadow-sm"
								src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}"
								alt="{$coverImage.altText|escape|default:''}"
							>
						{else}
							<a href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
								<img class="img-fluid rounded shadow-sm" src="{$issue->getLocalizedCoverImageUrl()|escape}" alt="{$issue->getLocalizedCoverImageAltText()|escape|default:''}">
							</a>
						{/if}
					</div>
				{/if}

				{* Article Galleys / PDF Download *}
				{if $primaryGalleys}
					<div class="item galleys mb-3">
						<ul class="value galleys_links list-unstyled m-0">
							{foreach from=$primaryGalleys item=galley}
								<li class="mb-2">
									{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley purchaseFee=$currentJournal->getData('purchaseArticleFee') purchaseCurrency=$currentJournal->getData('currency')}
								</li>
							{/foreach}
						</ul>
					</div>
				{/if}
				{if $supplementaryGalleys}
					<div class="item galleys supplementary-galleys mb-3">
						<ul class="value supplementary_galleys_links list-unstyled m-0">
							{foreach from=$supplementaryGalleys item=galley}
								<li class="mb-2">
									{include file="frontend/objects/galley_link.tpl" parent=$article publication=$publication galley=$galley isSupplementary="1"}
								</li>
							{/foreach}
						</ul>
					</div>
				{/if}

				{* Published Date *}
				{if $publication->getData('datePublished')}
					<div class="item published mb-2 border-top pt-2">
						<div class="label font-weight-bold text-dark small mb-1">
							{translate key="submissions.published"}:
						</div>
						<div class="value small text-muted">
							{if $firstPublication->getId() === $publication->getId()}
								<span>{$firstPublication->getData('datePublished')|date_format:$dateFormatShort}</span>
							{else}
								<span>{translate key="submission.updatedOn" datePublished=$firstPublication->getData('datePublished')|date_format:$dateFormatShort dateUpdated=$publication->getData('datePublished')|date_format:$dateFormatShort}</span>
							{/if}
						</div>
					</div>
				{/if}

				{* DOI *}
				{assign var=doiObject value=$article->getCurrentPublication()->getData('doiObject')}
				{if $doiObject}
					{assign var="doiUrl" value=$doiObject->getData('resolvingUrl')|escape}
					<div class="item doi mb-2 border-top pt-2">
						<div class="label font-weight-bold text-dark small mb-1">
							DOI:
						</div>
						<div class="value small text-break">
							<a href="{$doiUrl}" target="_blank" class="text-success font-weight-bold">
								{$doiUrl}
							</a>
						</div>
					</div>
				{/if}

				{* Keywords - checked from multiple possible variables *}
				{assign var="articleKeywords" value=$publication->getLocalizedData('keywords')}
				{if empty($articleKeywords) && !empty($keywords)}
					{if isset($keywords[$currentLocale])}
						{assign var="articleKeywords" value=$keywords[$currentLocale]}
					{else}
						{assign var="articleKeywords" value=$keywords}
					{/if}
				{/if}
				{if !empty($articleKeywords)}
					<div class="item keywords mb-2 border-top pt-2">
						<div class="label font-weight-bold text-dark small mb-1">
							{translate key="article.subject"}:
						</div>
						<div class="value small">
							{if is_array($articleKeywords)}
								{foreach from=$articleKeywords item="keyword"}
									<span class="badge badge-light border text-secondary font-weight-normal mr-1 mb-1 p-1" style="font-size: 0.78rem;">{$keyword|escape}</span>
								{/foreach}
							{else}
								<span class="text-muted small">{$articleKeywords|escape}</span>
							{/if}
						</div>
					</div>
				{/if}

				{* Issue article appears in *}
				{if $issue || $section}
					<div class="item issue border-top pt-2">
						{if $issue}
							<div class="sub_item mb-2">
								<div class="label font-weight-bold text-dark small mb-1">
									{translate key="issue.issue"}:
								</div>
								<div class="value small">
									<a class="title text-success font-weight-bold" href="{url page="issue" op="view" path=$issue->getBestIssueId()}">
										{$issue->getIssueIdentification()}
									</a>
								</div>
							</div>
						{/if}

						{if $section}
							<div class="sub_item">
								<div class="label font-weight-bold text-dark small mb-1">
									{translate key="section.section"}:
								</div>
								<div class="value small text-muted">
									{$section->getLocalizedTitle()|escape}
								</div>
							</div>
						{/if}
					</div>
				{/if}
			</div>
		</div>

		{* RIGHT COLUMN: Authors, Abstract, References, etc. *}
		<div class="col-12 col-md-9 col-lg-9 article-main-content">
			{* Authors Box *}
			{if $publication->getData('authors')}
				<div class="authors-card-box p-3 mb-3 rounded border bg-white shadow-sm">
					<ul class="authors-list list-unstyled m-0">
					{foreach from=$publication->getData('authors') item=author name=authorsLoop}
						<li class="author-item mb-2 pb-2 border-bottom-light">
							<div class="author-header d-flex align-items-center">
								<span class="author-name font-weight-bold text-dark mr-1">
									<i class="fa fa-user-circle text-secondary mr-2" style="font-size: 0.9rem;"></i>
									{$author->getFullName()|escape}
								</span>
								{if $author->getData('orcid')}
									<a href="{$author->getData('orcid')|escape}" target="_blank" class="mr-1">
										{if $author->getData('orcidAccessToken')}
											{$orcidIcon}
										{else}
											<i class="fa fa-id-badge text-success"></i>
										{/if}
									</a>
								{/if}
								{if $author->getLocalizedData('affiliation')}
									<button class="btn btn-link p-0 text-decoration-none border-0 ml-1 affiliation-toggle-btn {if $smarty.foreach.authorsLoop.first}active{/if}" type="button" onclick="var el=document.getElementById('aff-{$smarty.foreach.authorsLoop.index}'); if(el){ el.classList.toggle('d-none'); this.classList.toggle('active'); }" title="{translate key="user.affiliation"}">
										<span class="badge badge-light border text-secondary font-weight-normal py-1 px-2 affiliation-badge">
											<i class="fa fa-university text-success"></i> <i class="fa fa-chevron-down ml-1 toggle-icon" style="font-size: 0.65rem;"></i>
										</span>
									</button>
								{/if}
							</div>
							{if $author->getLocalizedData('affiliation')}
								<div class="author-affiliation-box {if !$smarty.foreach.authorsLoop.first}d-none{/if} mt-2" id="aff-{$smarty.foreach.authorsLoop.index}">
									<div class="author-affiliation small text-muted p-2 bg-light rounded border font-weight-normal">
										{$author->getLocalizedData('affiliation')|escape}
										{if $author->getData('rorId')}
											<a href="{$author->getData('rorId')|escape}">{$rorIdIcon}</a>
										{/if}
									</div>
								</div>
							{/if}
						</li>
					{/foreach}
					</ul>
				</div>
			{/if}

			{* Abstract *}
			{if $publication->getLocalizedData('abstract')}
				<div class="item abstract mb-3 p-3 rounded bg-white border">
					<h3 class="abstract-title text-center font-weight-bold mb-2 border-bottom pb-2" style="color: #014401; font-size: 1.1rem;">
						{translate key="article.abstract"}
					</h3>
					<div class="abstract-content text-justify" style="line-height: 1.6; font-size: 0.92rem; color: #333;">
						{$publication->getLocalizedData('abstract')|strip_unsafe_html}
					</div>
				</div>
			{/if}

			{call_hook name="Templates::Article::Main"}
			{call_hook name="Templates::Article::Details"}



			{* Author biographies *}
			{assign var="hasBiographies" value=0}
			{foreach from=$publication->getData('authors') item=author}
				{if $author->getLocalizedData('biography')}
					{assign var="hasBiographies" value=$hasBiographies+1}
				{/if}
			{/foreach}
			{if $hasBiographies}
				<div class="item author_bios mb-3 p-3 rounded border bg-white">
					<h3 class="label h6 font-weight-bold mb-2">
						{if $hasBiographies > 1}
							{translate key="submission.authorBiographies"}
						{else}
							{translate key="submission.authorBiography"}
						{/if}
					</h3>
					<ul class="authors list-unstyled m-0">
					{foreach from=$publication->getData('authors') item=author}
						{if $author->getLocalizedData('biography')}
							<li class="sub_item mb-2">
								<div class="label font-weight-bold small">
									{$author->getFullName()|escape}
								</div>
								<div class="value small text-muted">
									{$author->getLocalizedData('biography')|strip_unsafe_html}
								</div>
							</li>
						{/if}
					{/foreach}
					</ul>
				</div>
			{/if}

			{* References *}
			{if $parsedCitations || $publication->getData('citationsRaw')}
				<div class="item references mb-3 p-3 rounded border bg-white">
					<h3 class="label h6 font-weight-bold mb-2 border-bottom pb-2">
						{translate key="submission.citations"}
					</h3>
					<div class="value small text-secondary" style="line-height: 1.5; font-size: 0.85rem;">
						{if $parsedCitations}
							{foreach from=$parsedCitations item="parsedCitation"}
								<p class="mb-2">{$parsedCitation->getCitationWithLinks()|strip_unsafe_html} {call_hook name="Templates::Article::Details::Reference" citation=$parsedCitation}</p>
							{/foreach}
						{else}
							{$publication->getData('citationsRaw')|escape|nl2br}
						{/if}
					</div>
				</div>
			{/if}

			{* Licensing info *}
			{if $currentContext->getLocalizedData('licenseTerms') || $publication->getData('licenseUrl')}
				<div class="item copyright mb-3 p-3 rounded border bg-white small text-muted" style="font-size: 0.82rem;">
					<h3 class="label h6 font-weight-bold text-dark mb-2">
						{translate key="submission.license"}
					</h3>
					{if $publication->getData('licenseUrl')}
						{if $ccLicenseBadge}
							{if $publication->getLocalizedData('copyrightHolder')}
								<p class="mb-1">{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}</p>
							{/if}
							{$ccLicenseBadge}
						{else}
							<a href="{$publication->getData('licenseUrl')|escape}" class="copyright text-success">
								{if $publication->getLocalizedData('copyrightHolder')}
									{translate key="submission.copyrightStatement" copyrightHolder=$publication->getLocalizedData('copyrightHolder') copyrightYear=$publication->getData('copyrightYear')}
								{else}
									{translate key="submission.license"}
								{/if}
							</a>
						{/if}
					{/if}
					{$currentContext->getLocalizedData('licenseTerms')}
				</div>
			{/if}



		</div>
	</div><!-- .row -->

</article>
