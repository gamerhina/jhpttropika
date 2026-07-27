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
 {if $requestedPage|escape|default:"index" != 'index'}
         {* Sidebars *}
         <div class="sidebar col-xs-12 col-sm-2 col-md-3 mt-4 mt-lg-0">
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
 {/if}
</div>

<footer>
 <div class="bg-theme text-white">
     <div class="container-fluid px-4 px-lg-5">
         <div class="row row-cols-1 row-cols-sm-2 row-cols-md-5 pt-4 pt-lg-5 pb-2 pb-lg-3 mt-3 mt-lg-5">
             <div class="col-12 col-lg-4 mb-4 mb-pl-3 text-center">
                 <a href="{url page="about" op="aboutThisPublishingSystem"}">
                     <img class="img-responsive mt-1" alt="{translate key="about.aboutThisPublishingSystem"}" src="{$baseUrl}/{$brandImage}" style="height:100px">
                 </a>
             </div>

             {if $mailingAddress}
                 <div class="col-12 col-lg-4 mb-4 mb-pl-3">
                     <h5 class="mb-3">Mailing Address</h5>
                     <div class="content-box font-size-13">
                         {$mailingAddress|nl2br|strip_unsafe_html}
                     </div>
                 </div>
             {/if}

             <div class="col-12 col-lg-4 mb-4 mb-pl-3">
                 <h5 class="mb-3">Sources of Support</h5>
                 <div class="content-box font-size-13">
                     <p class="mb-2">
                         <b class="text-uppercase">
                         {if $contactName}
                         {$contactName|escape} 
                         {/if}
                         (Principal Contact)
                         </b>
                         <br/> 
                         {if $contactEmail}
                         Email: <a href="mailto:{$contactEmail|escape}" class="text-white">{$contactEmail|escape}</a> 
                         {/if}
                         {if $contactPhone}
                         | Phone: {$contactPhone|escape}
                         {/if}
                     </p>

                     <p class="mb-0">
                         <b class="text-uppercase">
                         {if $supportName}
                         {$supportName|escape} 
                         {/if}
                         (Support Contact)
                         </b>
                         <br/> 
                         {if $supportEmail}
                         Email: <a href="mailto:{$supportEmail|escape}" class="text-white">{$supportEmail|escape}</a> 
                         {/if}
                         {if $supportPhone}
                         | Phone: {$supportPhone|escape}
                         {/if}
                     </p>
                 </div>
             </div>
         </div>
     </div>
 </div>
 <div class="bg-black text-white">
     <div class="container-fluid px-lg-5 py-3 text-center">
         <p class="text-light mb-0 font-size-12 text-uppercase font-monospace">Copyright © 2022 - {$siteTitle}</p>
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
         if (window.scrollY > 100) {
             document.getElementById('navbar-top').classList.add('fixed-top');
             navbar_height = document.querySelector('.navbar-top').offsetHeight;
             document.body.style.paddingTop = navbar_height + 'px';
             document.getElementById('brand-name').classList.add('brand-name-letter-spacing-on-scroll');
             document.getElementById('header-box').classList.add('shadow');
         } else {
             document.getElementById('navbar-top').classList.remove('fixed-top');
             document.getElementById('header-box').classList.remove('shadow');
             document.getElementById('brand-name').classList.remove('brand-name-letter-spacing-on-scroll');
             document.body.style.paddingTop = '0';
         } 
     }
 });
}); 
</script>
</body>
</html>
