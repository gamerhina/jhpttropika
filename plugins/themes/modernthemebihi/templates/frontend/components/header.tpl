{**
 * lib/pkp/templates/frontend/components/header.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University Library
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Common frontend site header.
 *
 * @uses $isFullWidth bool Should this page be displayed without sidebars? This
 *       represents a page-level override, and doesn't indicate whether or not
 *       sidebars have been configured for thesite.
 *}

{* Determine whether a logo or title string is being displayed *}
{assign var="showingLogo" value=true}
{if $displayPageHeaderTitle && !$displayPageHeaderLogo && is_string($displayPageHeaderTitle)}
	{assign var="showingLogo" value=false}
{/if}

<!DOCTYPE html>
<html lang="{$currentLocale|replace:"_":"-"}" xml:lang="{$currentLocale|replace:"_":"-"}">
{if !$pageTitleTranslated}{capture assign="pageTitleTranslated"}{translate key=$pageTitle}{/capture}{/if}
{include file="frontend/components/headerHead.tpl"}
<body class="pkp_page_{$requestedPage|escape|default:"index"} pkp_op_{$requestedOp|escape|default:"index"}{if $showingLogo} has_site_logo{/if} unresponsive">
	<div class="pkp_structure_page">

		<nav id="accessibility-nav" class="sr-only" role="navigation" aria-label="{translate|escape key="plugins.themes.bootstrap3.accessible_menu.label"}">
			<ul>
			  <li><a href="#main-navigation">{translate|escape key="plugins.themes.bootstrap3.accessible_menu.main_navigation"}</a></li>
			  <li><a href="#main-content">{translate|escape key="plugins.themes.bootstrap3.accessible_menu.main_content"}</a></li>
			  <li><a href="#sidebar">{translate|escape key="plugins.themes.bootstrap3.accessible_menu.sidebar"}</a></li>
			</ul>
		</nav>

		{capture assign="primaryMenu"}
			{load_menu name="primary" id="main-navigation" ulClass="navbar-nav me-auto" liClass="nav-item "}
		{/capture}

		<div class="header-is-top">
			<div class="bg-theme {if !empty(trim($primaryMenu))} {/if}">
				<div class="container-non-responsive px-lg-3 px-0 py-0 text-center">
					{capture assign="homeUrl"}
						{url page="index" router=$smarty.const.ROUTE_PAGE}
					{/capture}
					{if $displayPageHeaderLogo}
						<a href="{$homeUrl}" class="navbar-brand navbar-brand-logo">
							<img src="{$publicFilesDir}/{$displayPageHeaderLogo.uploadName|escape:"url"}" {if $displayPageHeaderLogo.altText != ''}alt="{$displayPageHeaderLogo.altText|escape}"{/if} class="img-logo">
						</a>
					{elseif $displayPageHeaderTitle}
						<a href="{$homeUrl}" class="navbar-brand">{$displayPageHeaderTitle}</a>
					{else}
						<a href="{$homeUrl}" class="navbar-brand">
							<img src="{$baseUrl}/templates/images/structure/logo.png" alt="{$applicationName|escape}" title="{$applicationName|escape}" class="img-logo"/>
						</a>
					{/if}
				</div>
			</div>

			{if !empty(trim($primaryMenu))}
				<div class="mb-lg-2 bg-white shadow" id="is-header-fixed">
					<div class="container-non-responsive py-1">
						<nav class="navbar navbar-expand px-lg-3 py-1">
							{* <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
								<span class="navbar-toggler-icon"></span>
							</button> *}
							<div class="mantap">
								{$primaryMenu}
								{if $currentContext}
									{include file="frontend/components/searchForm_simple.tpl"}
								{/if}
								{capture assign="userMenu"}
									{load_menu name="user" id="main-navigation" ulClass="nav" liClass="nav-item"}
								{/capture} 
				
								{if !empty(trim($userMenu))}
									{$userMenu}
								{else}
									<ul class="nav">
										<li class="nav-item"><a href="{url page="user" op="register"}" class="nav-link link-success px-2 btn btn-sm btn-light py-1 ms-3 btn btn-success" style="margin-top:2px;hehe"><i class="fa fa-fw fa-user"></i> Register</a></li>
										<li class="nav-item"><a href="{url page="login"}" class="nav-link link-light px-2 ms-3 btn btn-success"><i class="fa fa-fw fa-user"></i> Login</a></li>
									</ul>
								{/if}
							</div>
						</nav>
					</div>
				</div>
			{/if}
		</div>

		{* Wrapper for page content and sidebars *}
		{include file="frontend/components/headerWrapperDiff.tpl"}
