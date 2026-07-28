{**
 * templates/frontend/objects/article_summary.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief View of an Article summary which is shown within a list of articles.
 *
 * @uses $article Article The article
 * @uses $hasAccess bool Can this user access galleys for this context? The
 *       context may be an issue or an article
 * @uses $showGalleyLinks bool Show galley links to users without access?
 * @uses $hideGalleys bool Hide the article galleys for this article?
 * @uses $primaryGenreIds array List of file genre ids for primary file types
 *}
 
 {* Bagian untuk menampilkan artikel pada Slideshow yang terletak di halaman utama *}
 {assign var=articlePath value=$article->getBestId($currentJournal)}
 {assign var=publication value=$article->getCurrentPublication()}
 {if (!$section.hideAuthor && $publication->getData('hideAuthor') == $smarty.const.AUTHOR_TOC_DEFAULT) || $publication->getData('hideAuthor') == $smarty.const.AUTHOR_TOC_SHOW}
     {assign var="showAuthor" value=true}
 {/if}
<li class="splide__slide">
    <div class="p-2 pb-3">
        <div class="row">
            <div class="col-3 col-md-3">
                <div class="cover media-left mb-2 md-lg-0">
                    {if $publication->getLocalizedData('coverImage')}
                        {assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
                        <a href="{if $journal}{url journal=$journal->getPath() page="article" op="view" path=$articlePath}{else}{url page="article" op="view" path=$articlePath}{/if}" class="file">
                            <img class="media-object img-thumbnail slideshow-img" src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}" alt="{$coverImage.altText|escape|default:''}">
                        </a>
                    {else}
                        <a href="{if $journal}{url journal=$journal->getPath() page="article" op="view" path=$articlePath}{else}{url page="article" op="view" path=$articlePath}{/if}" class="file">
                            <img class="media-object img-thumbnail slideshow-img" src="{$baseUrl}/plugins/themes/modernthemebihi/image/no-image-available.jpg" alt="No Images">
                        </a>
                    {/if}
                </div>
            </div>
            
        	{* Section untuk menampilkan Tanggal Published *}
            <div class="col-9 col-md-9 ps-0">
                <div class="">
                    {if $publication->getData('datePublished')}
                        <div class="list-group-item date-published mb-2 font-size-14">
                            <strong class="">Preview</strong> | {$publication->getData('datePublished')|date_format:$dateFormatShort}
                        </div>
                    {/if}
                </div>
                
	        	{* Section untuk menampilkan  Title *}
                <h5 class="media-heading mb-2">
                    <a href="{if $journal}{url journal=$journal->getPath() page="article" op="view" path=$articlePath}{else}{url page="article" op="view" path=$articlePath}{/if}" class="font-georgia font-size-18">
                        {$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
                        {if $publication->getLocalizedSubtitle(null, 'html')}
                            <p>
                                <small>{$publication->getLocalizedSubtitle(null, 'html')|escape}</small>
                            </p>
                        {/if}
                    </a>
                </h5>
                
        		{* Section untuk menampilkan Nama Author *}
                {if $showAuthor || $publication->getData('pages')}

                    {if $showAuthor}
                        <div class="meta mb-lg-2">
                            {if $showAuthor}
                                <div class="authors font-size-13">
                                    <img src="{$baseUrl}/plugins/themes/modernthemebihi/image/icon/icon-author.png" class="me-1" height="15px"/>{$publication->getAuthorString($authorUserGroups)|escape}
                                </div>
                            {/if}
                        </div>
                    {/if}

                {/if}
                
                 
        			{* Section untuk menampilkan DOI *}
                    {foreach from=$pubIdPlugins item=pubIdPlugin}
                        {if $pubIdPlugin->getPubIdType() != 'doi'}
                            {continue}
                        {/if}
                        {if $issue->getPublished()}
                            {assign var=pubId value=$article->getStoredPubId($pubIdPlugin->getPubIdType())}
                        {else}
                            {assign var=pubId value=$pubIdPlugin->getPubId($article)}{* Preview pubId *}
                        {/if}
                        {if $pubId}
                            {assign var="doiUrl" value=$pubIdPlugin->getResolvingURL($currentJournal->getId(), $pubId)|escape}
                            <div class="doi font-size-13">
                                {capture assign=translatedDoi}{translate key="plugins.pubIds.doi.readerDisplayName"}{/capture}
                                <img src="{$baseUrl}/plugins/themes/modernthemebihi/image/icon/icon-doi.png" class="me-1" height="15px"/>{translate key="semicolon" label=$translatedDoi} <a href="{$doiUrl}">{$doiUrl}</a>
                            </div>
                        {/if}
                    {/foreach}
        
        			{* Section untuk menghitung jumlah abstract view dan PDF download *}
                    {assign var=galleys value=$article->getGalleys()} 
                    <div class="pubId font-size-13 d-flex flex-wrap align-items-center gap-3 mt-2">
                        <span class="text-nowrap">
                            <img src="{$baseUrl}/plugins/themes/modernthemebihi/image/icon/icon-graph.png" class="me-1" height="15px"/>Abstract views: <span class="async-stats-view" data-type="article" data-id="{$article->getId()}"><i class="fa fa-spinner fa-spin"></i></span>
                        </span>
                        {if $galleys} 
                            {foreach from=$galleys item=galley name=galleyList} 
                                <span class="text-nowrap">
                                    <img src="{$baseUrl}/plugins/themes/modernthemebihi/image/icon/icon-pdf.png" class="me-1" height="15px"/>PDF downloads: <span class="async-stats-view" data-type="galley" data-id="{$galley->getData('submissionFileId')}"><i class="fa fa-spinner fa-spin"></i></span>
                                </span>
                            {/foreach} 
                        {/if}
                    </div>
            </div>
        </div>
        <br />
        <div class="mt-1 font-size-13">
            {if $publication->getLocalizedData('abstract')}
                {$publication->getLocalizedData('abstract')|strip_unsafe_html|strip_tags|nl2br|truncate:300:'...'}
            {/if}
        </div>
    </div>
    {call_hook name="Templates::Issue::Issue::Article"}
</li>
