<?php

namespace Drupal\soulusers\Controller;

use Drupal\Core\Controller\ControllerBase;
use Drupal\Core\Entity\EntityInterface;
use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\user\Entity\User;

/**
 * Class UserProfileController.
 */
class UserProfileController extends ControllerBase {

    /**
     * Returns a user's profile data.
     *
     * @param Drupal\Core\Entity\EntityInterface $user
     *   The user entity.
     *
     * @return Symfony\Component\HttpFoundation\JsonResponse
     *   The JSON response.
     */
    public function getUserProfile(EntityInterface $user, Request $request) {
        // Verificar se o token é válido
        $token = $request->headers->get('Authorization');
        if (!$this->validateToken($token)) {
            return new JsonResponse(['error' => 'Access denied'], 403);
        }

        if ($user instanceof User) {
            $data = [
                'uid' => $user->id(),
                'first_name' => $user->first_name->value, // Assumindo que esses campos existem
                'last_name' => $user->last_name->value,
                'birthday' => $user->birthday->value,
                'gender' => $user->gender->value,
                'roles' => $user->getRoles(),
            ];

            return new JsonResponse($data);
        }

        return new JsonResponse(['error' => 'User not found'], 404);
    }

    protected function validateToken($token) {
        return \Drupal::csrfToken()->validate($token);
    }
}
