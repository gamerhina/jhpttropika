{**
 * templates/frontend/components/footer.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Common site frontend footer.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}
 </main> 
 {* {if $requestedPage|escape|default:"index" != 'index'} *}
		 {* Sidebars *}
		 <div class="sidebar col-md-3-new p-1 mb-2">
			{if $requestedPage|escape|default:"index" == 'index'}         
			<div class="card w-100 border-0 shadow p-2 mb-2">
				<div class="">
					{if $thumb}
					<div class="mb-3 text-center pb-2">
						<div class="atlas-cover-stack">
							<a class="atlas-cover-stack-link" href="{$url}/issue/current" aria-label="View issue"></a>
							<div class="atlas-cover back"></div>
							<div class="atlas-cover front">
								<img class="media-object img-responsive cover_thumbnail lazyload w-100 rounded" 
									src="{$publicFilesDir}/{$journalFilesPath}/{$thumb.uploadName|escape:"url"}"{if $altText}
									alt="{$altText|escape}" {/if}>
							</div>
						</div>
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
			 {/if}
            
			 {if empty($isFullWidth)}
				 {capture assign="sidebarCode"}{call_hook name="Templates::Common::Sidebar"}{/capture}
				 {if $sidebarCode}
					 <aside id="sidebar" class="pkp_structure_sidebar" role="complementary" aria-label="{translate|escape key="common.navigation.sidebar"}">
						 {$sidebarCode}
					 </aside><!-- pkp_sidebar.left -->
				 {/if}
			 {/if}
		 </div>
	 </div>
 </div>
 {* {/if} *}
</div>

{* Footer *}
<style>
:root { --bg-theme: {$themeBaseColor|escape}; }
{if $mainBgImage}
body { background-image: url('{$mainBgImage|escape}'); background-size: cover; background-attachment: fixed; background-position: center; }
{/if}
{if $headerBgImage}
.navbar-top { background-image: url('{$headerBgImage|escape}'); background-size: cover; background-position: center; }
{/if}
</style>
<footer>

	{* Section menu 4 kolom yang ditampilkan pada Footer *}
	<div class="bg-white footer-top">
		<div class="container-non-responsive bg-white">
			<div class="py-3 px-lg-4 py-lg-3 font-size-14 text-center">
				{$pageFooter}
			</div>
		</div>
	</div>


	{* Section informasi terkait editorial office yang ditampilkan pada Footer *}
	<div class="bg-theme text-white">
		<div class="container-non-responsive bg-theme text-white">
			<div class="py-3 px-lg-4 py-lg-3 font-size-13">
				{$editorialFooter}
			</div>
		</div>
	</div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js" integrity="sha384-Xe+8cL9oJa6tN/veChSP7q+mnSPaj5Bcu9mPX5F5xIGE0DVittaqT5lorf0EI7Vk" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.min.js" integrity="sha384-kjU+l4N0Yf4ZOJErLsIcvOU2qSb74wXpOhqTvwVx3OElZRweTnQ6d31fXEoRD1Jy" crossorigin="anonymous"></script>

{load_script context="frontend" scripts=$scripts}

{call_hook name="Templates::Common::Footer::PageFooter"}

<script type="text/javascript">
 document.addEventListener("DOMContentLoaded", function(){		
	 window.addEventListener('scroll', function() {
		 if (window.innerWidth > 1000){
			 var headerFixed = document.getElementById('is-header-fixed');
			 var navbarTop = document.querySelector('.navbar-top');
			 if (headerFixed && navbarTop) {
				 if (window.scrollY > 200) {
					 headerFixed.classList.add('fixed-top');
					 navbar_height = navbarTop.offsetHeight;
					 document.body.style.paddingTop = navbar_height + 'px';
				 } else {
					 headerFixed.classList.remove('fixed-top');
					 document.body.style.paddingTop = '0';
				 } 
			 }
		 }
	 });

	 var splideFeature = new Splide( '#splide-slideshow', {
			 type   : '{$sliderTransition|escape|default:"loop"}',
			 perPage: 1,
			 perMove: 1,
			 arrows: false,
			 padding: "0px",
			 pagination: true,
			 autoplay: true,
             interval: {$sliderDuration|escape|default:"2500"},
			 breakpoints: {
				 720: {
					 perPage: 1,
					 padding: '40px'
				 },
			 },
		 } );

		 splideFeature.mount();
 }); 
</script>

{if $requestedPage|escape|default:"index" == 'index'}
<script src="https://cdn.jsdelivr.net/npm/@splidejs/splide@4.0.1/dist/js/splide.min.js"></script>
{/if}
</body>
</html>
