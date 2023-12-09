<?php

namespace Drupal\soulusers;

use Drupal\Core\Routing\RouteSubscriberBase;
use Symfony\Component\Routing\RouteCollection;

/**
 * Class PIcoreRouteSubscriber.
 */
class RestLoginAddonsRouteSubscriber extends RouteSubscriberBase {

    /**
     * {@inheritdoc}
     */
    public function alterRoutes(RouteCollection $collection) {
        $route_login = $collection->get('user.login.http');
        $route_login->setDefaults([
            '_controller' => '\Drupal\soulusers\Controller\RestLoginAddonsController::login',
        ]);
    }

}
