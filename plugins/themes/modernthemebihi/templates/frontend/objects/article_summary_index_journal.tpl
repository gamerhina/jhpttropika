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
 {assign var=articlePath value=$article->getBestId($currentJournal)}
 {assign var=publication value=$article->getCurrentPublication()}
 {if (!$section.hideAuthor && $publication->getData('hideAuthor') == $smarty.const.AUTHOR_TOC_DEFAULT) || $publication->getData('hideAuthor') == $smarty.const.AUTHOR_TOC_SHOW}
     {assign var="showAuthor" value=true}
 {/if}
 {assign var=widthColumn value="col-8"}
 <div class="col-12 col-md-12">
    <div class="card border-0 shadow-sm mt-2 article-card-hover">
        <div class="card-body border-top p-2">
            <div class="row">
                <div class="col-3 col-md-3 mb-lg-0">
                
                	{* Section menampilkan image pada Current Issue - Article *}
                    <div class="cover media-left">
                        {if $publication->getLocalizedData('coverImage')}
                            {assign var="coverImage" value=$publication->getLocalizedData('coverImage')}
                            <a href="{if $journal}{url journal=$journal->getPath() page="article" op="view" path=$articlePath}{else}{url page="article" op="view" path=$articlePath}{/if}" class="file">
                                <img class="media-object img-thumbnail article-img" src="{$publication->getLocalizedCoverImageUrl($article->getData('contextId'))|escape}" alt="{$coverImage.altText|escape|default:''}">
                            </a>
                        {else}
                            <a href="{if $journal}{url journal=$journal->getPath() page="article" op="view" path=$articlePath}{else}{url page="article" op="view" path=$articlePath}{/if}" class="file">
                                <img class="media-object img-thumbnail article-img" src="{$baseUrl}/plugins/themes/modernthemebihi/image/no-image-available.jpg" alt="No Images">
                            </a>
                        {/if}
                    </div>
                </div>
                
               {* Section menampilkan Title pada Current Issue - Article *} 
                <div class="col-9 col-md-9 ps-0">
                    <h5 class="media-heading mb-3">
                        <a href="{if $journal}{url journal=$journal->getPath() page="article" op="view" path=$articlePath}{else}{url page="article" op="view" path=$articlePath}{/if}" class="font-georgia font-size-18">
                            {$publication->getLocalizedTitle(null, 'html')|strip_unsafe_html}
                            {if $publication->getLocalizedSubtitle(null, 'html')}
                                <p>
                                    <small>{$publication->getLocalizedSubtitle(null, 'html')|escape}</small>
                                </p>
                            {/if}
                        </a>
                    </h5>


              		{* Section menampilkan Author pada Current Issue - Article *} 
                    {if $showAuthor}
                        <div class="meta mb-2">
                            {if $showAuthor}
                                <div class="authors font-size-13">
                                    <img src="{$baseUrl}/plugins/themes/modernthemebihi/image/icon/icon-author.png" class="me-1" height="15px"/><!-- DEBUG_V2: {$authorUserGroups|@get_class|default:'NULL'} -->{$publication->getAuthorString($authorUserGroups)|escape}
                                </div>
                            {/if}
                        </div>
                    {/if}
                    
              		{* Section menampilkan DOI pada Current Issue - Article *} 
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
        
              		{* Section menampilkan informasi jumlah Abstract views dan PDF download pada Current Issue - Article *} 
                    {assign var=galleys value=$article->getGalleys()} 
                    <div class="pubId font-size-13">
                        <img src="{$baseUrl}/plugins/themes/modernthemebihi/image/icon/icon-graph.png" class="me-1" height="15px"/>Abstract views: <span class="async-stats-view" data-type="article" data-id="{$article->getId()}"><i class="fa fa-spinner fa-spin"></i></span> 
                        {if $galleys} 
                            {foreach from=$galleys item=galley name=galleyList} 
                                <img src="{$baseUrl}/plugins/themes/modernthemebihi/image/icon/icon-pdf.png" class="me-1 ms-3" height="15px"/>PDF downloads: <span class="async-stats-view" data-type="galley" data-id="{$galley->getData('submissionFileId')}"><i class="fa fa-spinner fa-spin"></i></span> 
                            {/foreach} 
                        {/if}
                    </div>

              		{* Section menampilkan informasi jumlah page pada Current Issue - Article *} 
                    <div class="row mt-2">
                        <div class="col-6">
                            {if $publication->getData('pages')}
                                <p class="pages font-size-13 mb-0">
                                    {$publication->getData('pages')|escape} Pages
                                </p>
                            {/if}
                        </div>
                        
              			{* Section menampilkan button untuk diarahkan ke download PDF pada Current Issue - Article *} 
                        <div class="col-6">
                            {if !$hideGalleys && $article->getGalleys()}
                                <div class="btn-group pull-right" role="group">
                                    {foreach from=$article->getGalleys() item=galley}
                                        {if $primaryGenreIds}
                                            {assign var="file" value=$galley->getFile()}
                                            {if !$galley->getRemoteUrl() && !($file && in_array($file->getGenreId(), $primaryGenreIds))}
                                                {continue}
                                            {/if}
                                        {/if}
                                        {assign var="hasArticleAccess" value=$hasAccess}
                                        {assign var="hasArticleAccess" value=$hasAccess}
                                        {if $currentContext->getSetting('publishingMode') == $smarty.const.PUBLISHING_MODE_OPEN || $publication->getData('accessStatus') == $smarty.const.ARTICLE_ACCESS_OPEN}
                                            {assign var="hasArticleAccess" value=1}
                                        {/if}
                                        {include file="frontend/objects/galley_link.tpl" parent=$article hasAccess=$hasArticleAccess}
                                    {/foreach}
                                </div>
                            {/if}
                        </div>
                    </div>
                </div>
            </div>
        </div>
    
        {call_hook name="Templates::Issue::Issue::Article"}
    </div>
 </div>
