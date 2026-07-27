<?php
/**
 * @file classes/components/form/publication/PKPCitationsForm.php
 *
 * Copyright (c) 2014-2021 Simon Fraser University
 * Copyright (c) 2000-2021 John Willinsky
 * Distributed under the GNU GPL v3. For full terms see the file docs/COPYING.
 *
 * @class PKPCitationsForm
 *
 * @ingroup classes_controllers_form
 *
 * @brief A preset form for setting a publication's citations
 */

namespace PKP\components\forms\publication;

use APP\publication\Publication;
use PKP\components\forms\FieldRichTextarea;
use PKP\components\forms\FormComponent;

define('FORM_CITATIONS', 'citations');

class PKPCitationsForm extends FormComponent
{
    public $id = FORM_CITATIONS;
    public $method = 'PUT';
    public bool $isRequired;

    /**
     * Constructor
     *
     * @param string $action URL to submit the form to
     */
    public function __construct(string $action, Publication $publication, bool $isRequired = false)
    {
        $this->action = $action;
        $this->isRequired = $isRequired;

        $this->addField(new FieldRichTextarea('citationsRaw', [
            'label' => __('submission.citations'),
            'description' => __('submission.citations.description') . '<style>.tox-fullscreen .tox-tinymce { height: 100vh !important; width: 100vw !important; } .tox-fullscreen { height: 100vh !important; width: 100vw !important; }</style>',
            'value' => $publication->getData('citationsRaw'),
            'isRequired' => $isRequired,
            'plugins' => 'paste,link,noneditable,image,lists,table,code,charmap,fullscreen',
            'toolbar' => 'bold italic underline strikethrough | alignleft aligncenter alignright alignjustify | bullist numlist | outdent indent | table link image | charmap code fullscreen',
            'init' => [
                'menubar' => 'file edit view insert format tools table'
            ],
        ]));
    }
}
