<?php

namespace Drupal\soulusers\Listener;

use Drupal\Component\EventDispatcher\ContainerAwareEventDispatcher;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\HttpKernel\KernelEvents;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpKernel\Event\FilterResponseEvent;
use Symfony\Component\HttpKernel\Event\GetResponseEvent;
use Symfony\Component\HttpFoundation\RedirectResponse;
use Symfony\Component\HttpFoundation\Request;
use Drupal\Component\Serialization\Xml;
use Drupal\Component\Serialization\Json;
use Symfony\Contracts\EventDispatcher\Event;
use Symfony\Component\HttpKernel\Event\ResponseEvent;

/**
 * Class SoulLoginListener.
 *
 * @package Drupal\example
 */
class SoulLoginListener implements EventSubscriberInterface
{

    /**
     * @var path.current service
     */
    private $currentPath;

    /**
     * @var \Drupal\Core\Session\AccountInterface
     */
    private $currentUser;

    /**
     * Constructor with dependency injection
     */
    public function __construct($currentPath, $currentUser) {
        $this->currentPath = $currentPath;
        $this->currentUser = $currentUser;
    }

    /**
     * Add JWT access token to user login API response
     */
    public function onHttpLoginResponse(ResponseEvent $event) {
        // Halt if not user login request
        if ($this->currentPath->getPath() !== '/user/login') {
            return;
        }

        // Get response
        $response = $event->getResponse();

        \Drupal::logger('soulusers')->notice($response->getContent());
        // Ensure not error response
        if ($response->getStatusCode() !== 200) {
            return;
        }
        \Drupal::logger('soul_login')->notice(' pass 200');

        \Drupal::logger('soul_login')->notice($response);


        // Decode and add JWT token
        if ($content = $response->getContent()) {
            if ($decoded = Json::decode($content)) {
                $user_role = $this->currentUser->getRoles();
                $user_uuid = $this->currentUser->id();
                $decoded['user_uid'] = $user_uuid;
                $decoded['user_role'] = $user_role;
                // Set new response JSON
                $response->setContent(Json::encode($decoded));
                $event->setResponse($response);
            }
        }
    }

    /**
     * The subscribed events.
     */
    public static function getSubscribedEvents() {
        $events = [];
        $events[KernelEvents::RESPONSE][] = ['onHttpLoginResponse'];
        return $events;
    }

}