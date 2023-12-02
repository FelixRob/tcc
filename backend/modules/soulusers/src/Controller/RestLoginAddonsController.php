<?php

namespace Drupal\soulusers\Controller;

use Drupal\Core\Access\CsrfTokenGenerator;
use Drupal\Core\Entity\EntityTypeManagerInterface;
use Drupal\Core\Flood\FloodInterface;
use Drupal\Core\Routing\RouteProviderInterface;
use Drupal\user\Controller\UserAuthenticationController;
use Drupal\user\UserAuthInterface;
use Drupal\user\UserStorageInterface;
use Psr\Log\LoggerInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\Serializer\Encoder\JsonEncoder;
use Symfony\Component\Serializer\Serializer;

/**
 * Felix R.
 * December 2023
 * Class RestLoginAddonsController.
 *
 * We are altering the user. Login route to add all the custom fields here.
 */
class RestLoginAddonsController extends UserAuthenticationController {

    /**
     * Logs in a user.
     *
     * @param \Symfony\Component\HttpFoundation\Request $request
     *   The request.
     *
     * @return \Symfony\Component\HttpFoundation\Response
     *   A response which contains the ID and CSRF token.
     */
    public function login(Request $request) {
        $response_data = parent::login($request);

        // We need to fetch the uid and load the user.
        $content = $response_data->getContent();
        $decoded_data = $this->serializer->decode($content, 'json');
        $uid = $decoded_data['current_user']['uid'];
        $user = $this->userStorage->load($uid);

        // Fetching the custom data.
        $decoded_data = $this->fetchCustomfields($user, $decoded_data);
        $encoded_custom_data = $this->serializer->encode($decoded_data, 'json');
        $response_data->setContent($encoded_custom_data);
        return $response_data;
    }

    /**
     * Fetching custom fields.
     *
     * @param object $user
     *   The user object.
     * @param array $response_data
     *   The array of responses.
     *
     * @return mixed
     *   The response
     */
    protected function fetchCustomfields($user, array $response_data) {
      $response_data['uuid'] = $user->get('uuid')->value;
      $response_data['roles'] = $user->getRoles();
      $response_data['first_name'] = $user->get('first_name')->value;
      $response_data['last_name'] = $user->get('last_name')->value;
      $response_data['gender'] = $user->get('gender')->value;

      return $response_data;
    }

}
