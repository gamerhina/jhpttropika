{**
 * templates/frontend/pages/contact.tpl
 *
 * Copyright (c) 2014-2018 Simon Fraser University
 * Copyright (c) 2003-2018 John Willinsky
 * Distributed under the GNU GPL v2. For full terms see the file docs/COPYING.
 *
 * @brief Display the page to view the press's contact details.
 *
 * @uses $currentContext Journal|Press The current journal or press
 * @uses $mailingAddress string Mailing address for the journal/press
 * @uses $contactName string Primary contact name
 * @uses $contactTitle string Primary contact title
 * @uses $contactAffiliation string Primary contact affiliation
 * @uses $contactPhone string Primary contact phone number
 * @uses $contactEmail string Primary contact email address
 * @uses $supportName string Support contact name
 * @uses $supportPhone string Support contact phone number
 * @uses $supportEmail string Support contact email address
 *}
{include file="frontend/components/header.tpl" pageTitle="about.contact"}

<div class="page page_contact">
	{include file="frontend/components/breadcrumbs.tpl" currentTitleKey="about.contact"}

	{* Contact section *}
	<div class="contact_section">
		<div class="shadow-sm rounded p-3">
			{if $mailingAddress}
				<div class=""><strong><i class="fa fa-envelope-o" aria-hidden="true"></i> Mailing Address</strong></div>
				<div class="" style="">
					{$mailingAddress|nl2br|strip_unsafe_html}
				</div>
				<hr/>
			{/if}

			<div class="row">
				{* Primary contact *}
				{if $contactTitle || $contactName || $contactAffiliation || $contactPhone || $contactEmail}
					<div class="col">
						<div class="contact primary">
							<h5>
								{translate key="about.contact.principalContact"}
							</h5>

							{if $contactName}
							<div class="name">
								<i class="fa fa-user fa-fw" aria-hidden="true"></i> {if $contactTitle} {$contactTitle|escape}  {/if} {$contactName|escape}
							</div>
							{/if}

							{if $contactAffiliation}
							<div class="affiliation">
								{$contactAffiliation|strip_unsafe_html}
							</div>
							{/if}

							{if $contactPhone}
							<div class="phone">
								<i class="fa fa-phone-square fa-fw" aria-hidden="true"></i>	{$contactPhone|escape}
							</div>
							{/if}

							{if $contactEmail}
							<div class="email">
								<i class="fa fa-envelope-o fa-fw" aria-hidden="true"></i>	
								<a href="mailto:{$contactEmail|escape}">
									{$contactEmail|escape}
								</a>
							</div>
							{/if}
						</div>
					</div>
				{/if}

				{* Technical contact *}
				{if $supportName || $supportPhone || $supportEmail}
					<div class="col">
						<div class="contact support">
							<h5>
								{translate key="about.contact.supportContact"}
							</h5>

							{if $supportName}
							<div class="name">
									<i class="fa fa-user fa-fw" aria-hidden="true"></i>  {$supportName|escape}
							</div>
							{/if}

							{if $supportPhone}
							<div class="phone">                
								<i class="fa fa-phone-square fa-fw" aria-hidden="true"></i> {$supportPhone|escape}				
							</div>
							{/if}

							{if $supportEmail}
							<div class="email">
								<i class="fa fa-envelope-o fa-fw" aria-hidden="true"></i>	
								<a href="mailto:{$supportEmail|escape}">
									{$supportEmail|escape}
								</a>
							</div>
							{/if}
						</div>
					</div>
				{/if}
			</div>
		</div>
	</div>

</div><!-- .page -->

{include file="frontend/components/footer.tpl"}
