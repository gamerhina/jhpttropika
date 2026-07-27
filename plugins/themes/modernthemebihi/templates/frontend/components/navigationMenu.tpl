{**
 * templates/frontend/components/navigationMenu.tpl
 *
 * Copyright (c) 2014-2017 Simon Fraser University
 * Copyright (c) 2003-2017 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Primary navigation menu list for OJS
 *
 * @uses navigationMenu array Hierarchical array of navigation menu item assignments
 * @uses id string Element ID to assign the outer <ul>
 * @uses ulClass string Class name(s) to assign the outer <ul>
 * @uses liClass string Class name(s) to assign all <li> elements
 *}

{if $navigationMenu} 

	<ul id="{$id|escape}" class="{$ulClass|escape}">
		{foreach key=field item=navigationMenuItemAssignment from=$navigationMenu->menuTree name=menu}
		
			{assign "contentMenuIsPrimary" $navigationMenuItemAssignment->_data['menuId']}
			{if !$navigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
				{continue}
			{/if}
			{assign var="hasChildren" value=false}
			{if !empty($navigationMenuItemAssignment->children)}
				{assign var="hasChildren" value=true}
			{/if}
			{if $hasChildren}
				<li class="dropdown">
					<a class="nav-link dropdown-toggle ps-2 {($contentMenuIsPrimary==2) ? 'link-dark me-2' : 'link-light ms-3'}" href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown" aria-expanded="false">
						{$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
						{if $hasChildren}
							<span class="caret caret123"></span>
						{/if}
					</a>
					{if !empty($navigationMenuItemAssignment->children)}
						<ul class="dropdown-menu {if $id === 'navigationUser'}dropdown-menu-right{/if}">
							{foreach key=childField item=childNavigationMenuItemAssignment from=$navigationMenuItemAssignment->children}
								{if $childNavigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
									{* <li class="{$liClass|escape}"> *}
									<li>
										<a href="{$childNavigationMenuItemAssignment->navigationMenuItem->getUrl()}" class="dropdown-item">
											{$childNavigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
										</a>
									</li>
								{/if}
							{/foreach}
						</ul>
					{/if}
				</li>
			{else}
				<li class="nav-item">
					{if $navigationMenuItemAssignment->navigationMenuItem->getType() == 'NMI_TYPE_USER_REGISTER'}
						<a href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}"  class="nav-link px-2 btn btn-sm py-1 {($contentMenuIsPrimary==2) ? 'link-dark me-2' : 'link-light ms-3'}" style="margin-top:2px;"> {$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}</a>
					{else}
						<a href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}" class="nav-link px-2 {($contentMenuIsPrimary==2) ? 'link-dark me-2' : 'link-light ms-3'}">{$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}</a>
					{/if}
				</li>
			{/if}
			{* {$navigationMenuItemAssignment->navigationMenuItem|@var_dump} *}
			
			{* <li class="{$liClass|escape}{if $hasChildren} dropdown{/if}">
				<a href="{$navigationMenuItemAssignment->navigationMenuItem->getUrl()}"{if $hasChildren} class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"{/if}>
					{$navigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
					{if $hasChildren}
						<span class="caret"></span>
					{/if}
				</a>
				{if !empty($navigationMenuItemAssignment->children)}
					<ul class="dropdown-menu {if $id === 'navigationUser'}dropdown-menu-right{/if}">
						{foreach key=childField item=childNavigationMenuItemAssignment from=$navigationMenuItemAssignment->children}
							{if $childNavigationMenuItemAssignment->navigationMenuItem->getIsDisplayed()}
								<li class="{$liClass|escape}">
									<a href="{$childNavigationMenuItemAssignment->navigationMenuItem->getUrl()}" class="{$aClass|escape}">
										{$childNavigationMenuItemAssignment->navigationMenuItem->getLocalizedTitle()}
									</a>
								</li>
							{/if}
						{/foreach}
					</ul>
				{/if}
			</li> *}
		{/foreach}
	</ul>
{/if}


