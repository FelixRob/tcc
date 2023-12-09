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

        // Obter o usuário atual
        $currentUser = \Drupal::currentUser();
        $userId = $user->id();

        if (!$currentUser->hasPermission('administer users')
            && $userId !== $currentUser->id() && !$this->checkFriendship($currentUser->id(), $userId)) {
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

    /**
     * Verifica se existe uma amizade entre dois usuários.
     *
     * @param int $userId1
     *   ID do primeiro usuário.
     * @param int $userId2
     *   ID do segundo usuário.
     *
     * @return bool
     *   Retorna TRUE se existir uma amizade, FALSE caso contrário.
     */
    protected function checkFriendship($userId1, $userId2) {
        $query = \Drupal::database()->select('friendship', 'f');
        $query->fields('f', ['fid']);  // Assumindo que 'fid' é o identificador da amizade
        $query->condition('f.uid_1', $userId1, '=');
        $query->condition('f.uid_2', $userId2, '=');
        $query->condition('f.level', -1, '!=');
        $query->range(0, 1);  // Limita a busca a um resultado

        $result = $query->execute()->fetchField();
        return !empty($result);  // Se encontrar uma amizade, retorna TRUE
    }
}
