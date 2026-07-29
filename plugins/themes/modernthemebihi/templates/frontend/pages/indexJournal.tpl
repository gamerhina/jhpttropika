{**
 * templates/frontend/pages/indexJournal.tpl
 *
 * UPDATED/CHANGED/MODIFIED: Marc Behiels - marc@elemental.ca - 250416
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the index page for a journal
 *
 * @uses $currentJournal Journal This journal
 * @uses $journalDescription string Journal description from HTML text editor
 * @uses $homepageImage object Image to be displayed on the homepage
 * @uses $additionalHomeContent string Arbitrary input from HTML text editor
 * @uses $announcements array List of announcements
 * @uses $numAnnouncementsHomepage int Number of announcements to display on the
 *       homepage
 * @uses $issue Issue Current issue
 *}

{include file="frontend/components/header.tpl" pageTitleTranslated=$currentJournal->getLocalizedName()}

	{capture assign="url"}{url journal=$currentJournal->getPath()}{/capture}
	{assign var="thumb" value=$currentJournal->getLocalizedSetting('journalThumbnail')}
	{assign var="description" value=$currentJournal->getLocalizedDescription()}
	{assign var="onlineIssn" value=$currentJournal->getSetting('onlineIssn')}
	{assign var="printIssn" value=$currentJournal->getSetting('printIssn')}
	{assign var="publisher" value=$currentJournal->getSetting('publisherInstitution')}

	<div class="card w-100 border-0 shadow p-2">
		{if $homepageImage}
			<div class="homepage-image pb-4 mb-3 border-bottom">
				<img class="img-responsive w-100 rounded" src="{$publicFilesDir}/{$homepageImage.uploadName|escape:"url"}" alt="{$homepageImageAltText|escape}">
			</div>
		{/if}

		{if $journalDescription}
			<div class="journal-description font-size-16">
				{$journalDescription}
			</div>
		{/if}

		{* Bagian slideshow artikel pada current issue menggunakan splide *}
		{if $issue}
			<section class="slideshow-section rounded mb-2" id="slideshow">
				<div class="p-0">
					<div class="splide" id="splide-slideshow" role="group" aria-label="Splide Basic HTML Example">
						<div class="splide__track">
							<ul class="splide__list">
								{if $sliderImage1 || $sliderImage2 || $sliderImage3}
									{if $sliderImage1}
									<li class="splide__slide" style="position: relative;">
										{if $sliderLink1}<a href="{$sliderLink1|escape}">{/if}
										<img src="{$sliderImage1|escape}" alt="Slider 1" style="width: 100%; height: auto; border-radius: 8px;">
										{if $sliderCaption1}
										<div style="position: absolute; bottom: 20px; left: 20px; right: 20px; background: rgba(0,0,0,0.6); color: #fff; padding: 10px; border-radius: 4px; text-align: center;">{$sliderCaption1|escape}</div>
										{/if}
										{if $sliderLink1}</a>{/if}
									</li>
									{/if}
									{if $sliderImage2}
									<li class="splide__slide" style="position: relative;">
										{if $sliderLink2}<a href="{$sliderLink2|escape}">{/if}
										<img src="{$sliderImage2|escape}" alt="Slider 2" style="width: 100%; height: auto; border-radius: 8px;">
										{if $sliderCaption2}
										<div style="position: absolute; bottom: 20px; left: 20px; right: 20px; background: rgba(0,0,0,0.6); color: #fff; padding: 10px; border-radius: 4px; text-align: center;">{$sliderCaption2|escape}</div>
										{/if}
										{if $sliderLink2}</a>{/if}
									</li>
									{/if}
									{if $sliderImage3}
									<li class="splide__slide" style="position: relative;">
										{if $sliderLink3}<a href="{$sliderLink3|escape}">{/if}
										<img src="{$sliderImage3|escape}" alt="Slider 3" style="width: 100%; height: auto; border-radius: 8px;">
										{if $sliderCaption3}
										<div style="position: absolute; bottom: 20px; left: 20px; right: 20px; background: rgba(0,0,0,0.6); color: #fff; padding: 10px; border-radius: 4px; text-align: center;">{$sliderCaption3|escape}</div>
										{/if}
										{if $sliderLink3}</a>{/if}
									</li>
									{/if}
								{else}
									{foreach name=sections from=$publishedSubmissions item=section}
										{if $section.articles}
											{foreach from=$section.articles item=article name=article}

												{include file="frontend/objects/article_slideshow_index_journal.tpl"}
											{/foreach}
										{/if}
									{/foreach}
								{/if}
							</ul>
						</div>
					</div>
				</div>
			</section>

			{* Bagian Current Article pada Volume terakhir yang dimunculkan pada halaman utama *}
			<div class="current-article-list">
				{foreach name=sections from=$publishedSubmissions item=section}
					<div class="section">
						{if $section.articles}
							<div class="d-md-flex flex-md-row-reverse align-items-center justify-content-between border-bottom py-2 mb-0 text-center text-lg-left">
								<a href="{$url}/issue/current">
									<span class="btn btn-sm btn-dark mb-3 mb-lg-0"> 
										<i class="fa fa-chevron-right" aria-hidden="true"></i> More Articles 
									</span>
								</a>
								{if $section.title}
									<div class="page-header">
										<h4 class="mb-0">
											{$section.title|escape}
										</h4>
									</div>
								{/if}
							</div>
							<div class="row">
								{foreach from=$section.articles item=article name=article}

									{include file="frontend/objects/article_summary_index_journal.tpl"}
								{/foreach}
							</div>
						{/if}
					</div>
				{/foreach}
			</div>
		{/if}
	</div>

	{* <div class="pkp_structure_content container-non-responsive margin-top-floating">
		<div id="main-content" class="index-journal">
			{call_hook name="Templates::Index::journal"}
			<div class="px-lg-3 akwjeh">
				<div class="col-md-3-new p-1">
					<div class="card w-100 border-0 shadow p-2">
						<div class="">
							{if $thumb}
							<div class="mb-2 text-center border-bottom pb-2">
								<img class="media-object img-responsive cover_thumbnail lazyload w-100 rounded" 
									src="{$publicFilesDir}/{$journalFilesPath}/{$thumb.uploadName|escape:" url"}"{if $altText}
									alt="{$altText|escape}" {/if}>  
							</div>
							{/if}
		
							{if $issue}
							<div class="current_issue text-left">
								<div class="page-header mb-2">
									<h5 class="m-0">
										{translate key="journal.currentIssue"}
									</h5>
								</div>
								<p class="current_issue_title lead mb-2 font-size-14  border-bottom pb-2">
									<a href="{$url}/issue/current">{$issue->getIssueIdentification()|strip_unsafe_html}</a>
								</p>
			
								<div class="meta font-size-14 text-left">
									{if $onlineIssn}
									<p class="mb-2"><b>Online ISSN</b> : <a href="https://portal.issn.org/resource/issn/{$onlineIssn}">
											{$onlineIssn} </a> </p>
									{/if}
			
									{if $printIssn}
									<p class="mb-2"><b>Print ISSN</b> : <a href="https://portal.issn.org/resource/issn/{$printIssn}">
											{$printIssn} </a> </p>
									{/if}
			
			
									{if $publisher}
									<p class="mb-0"><b>Publisher </b> : {$publisher} </a> </p>
									{/if}
								</div>
		
							</div>
							{/if}		
						</div>
					</div>
					{include file="frontend/components/sidebar_hardcode_left.tpl"}
				</div>
				<div class="col-md-6-new p-1 pb-lg-3">

				</div>
				<div class="col-md-3-new p-1">
					{include file="frontend/components/sidebar_hardcode_right.tpl"}
				</div>
			</div>
		</div>
	</div> *}

	{* <div class="bg-light py-5">
	{include file="frontend/objects/collection.tpl" heading="h3"}
	</div> *}

{include file="frontend/components/footer.tpl"}
