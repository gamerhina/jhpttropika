<head>
	<meta charset="{$defaultCharset|escape}">
	{* <meta name="viewport" content="width=device-width, initial-scale=0"> *}
	{* <meta name="viewport" content="width=900, initial-scale=1, shrink-to-fit=no"> *}
	<title>
		{$pageTitleTranslated|strip_tags}
		{* Add the journal name to the end of page titles *}
		{if $requestedPage|escape|default:"index" != 'index' && $currentContext && $currentContext->getLocalizedName()}
			| {$currentContext->getLocalizedName()}
		{/if}
	</title>

	{load_header context="frontend"}

	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-0evHe/X+R7YkIZDRvuzKMRqM+OrBnVFBL6DOitfPri4tjfHxaWutUpFmBp4vmVor" crossorigin="anonymous">
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.css" integrity="sha256-NuCn4IvuZXdBaFKJOAcsU2Q3ZpwbdFisd5dux4jkQ5w=" crossorigin="anonymous">

	{if $requestedPage|escape|default:"index" == 'index'}
		<link rel="stylesheet" href="https://cdn.jsdelivr.net/combine/npm/@splidejs/splide@4.0.1/dist/css/splide.min.css,npm/@splidejs/splide@4.0.1/dist/css/splide-core.min.css">
	{/if}
	
	{load_stylesheet context="frontend"}
</head>
