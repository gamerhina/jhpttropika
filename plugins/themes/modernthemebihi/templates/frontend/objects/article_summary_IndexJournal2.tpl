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
 {assign var=smarty_version value=$smarty.version|substr:0:1}

 {assign var=articlePath value=$article->getBestArticleId($currentJournal)}
 {if (!$section.hideAuthor && $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_DEFAULT) || $article->getHideAuthor() == $smarty.const.AUTHOR_TOC_SHOW}
     {assign var="showAuthor" value=true}
 {/if}
 
 <div class="article-summary col-md-3">
     {* {if $article->getLocalizedCoverImage()}
         <div class="cover media-left">
             <a href="{url page="article" op="view" path=$article->getId()}" class="file">
                 <img class="media-object" src="{$article->getLocalizedCoverImageUrl()|escape}">
             </a>
         </div>
     {/if} *}
 
     <div class="article_summary">
         <div class="row article_title">
             <div class="col-md-12">
                 <h3 class="text-justify">
                     <a href="{url page="article" op="view" path=$article->getId()}" class="article_name">
                         {$article->getLocalizedTitle()|strip_unsafe_html}
                         {if $article->getLocalizedSubtitle()}
                             <p class="article_subtitle">
                                 <small >{$article->getLocalizedSubtitle()|escape}</small>
                             </p>
                         {/if}
                     </a>
                 </h3>
             </div>
         </div>
 
         {if $showDoiOnIndex}		
         
         {assign var=doi value=$article->_data['pub-id::doi']}	
 
             {if $doi }
                 <div class="row journal_index_doi ">	
                     <div class="col-md-12 no-padding">							
                         <span class="doi_logo"> </span>
                         <a href="{url page="article" op="view" path=$articlePath}" class="doi_link">
                             {$doi}
                         </a>
                     </div>	
                 </div>
             {/if}
 
         {/if}
 
 
 
         <div class="row meta">
 
                 <div class="col-md-6 col-xs-6 date_published">{$article->getDatePublished()|date_format}</div>
                 {if $article->getPages()}					
                         <div class="col-md-6 col-xs-6 pages text-right">
                             <i class="fa fa-file-text-o" aria-hidden="true"></i> <span class="page_number"> {$article->getPages()|escape} </span>
                         </div>		
                 {/if}
 
                 {if $showAuthor}
                         <div class="col-md-12 col-xs-12 author" >
                             {if $showAuthor}						
                                     <span ><i class="fa fa-users"> </i> {$article->getAuthorString()}	</span>
                             {/if}
                         </div>
                 {/if}
 
             
                     
 
 
 
                     {if !$hideGalleys && $article->getGalleys()}
                     
                     <div class="galley_list pull-left"> 
                         {* make compatible with ojs 3.1.1.4 *}
                             {if $smarty_version == '2'} 
                                 {include file="legacy/articleSummary_galley_v2.tpl"}
                             {else}
                                 {include file="legacy/articleSummary_galley_v3.tpl"}
                             {/if}
                         {* end compatible check *}
 
                         
                         
                     </div>
 
 
                         {if $enableStatistic != 'no'}
                         <div class="article_counter_stat text-right pull-right"> <span class="article_counter_read"></span> Statistic: {$article->getViews()} </div>
                         {/if}
 
                     
 
                     
                 {/if}
             </div>
 
 
         
     </div>
 
     {call_hook name="Templates::Issue::Issue::Article"}
 </div><!-- .article-summary -->
 
