<?php

namespace Drupal\friendship\Controller;

use Drupal\Core\Controller\ControllerBase;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\JsonResponse;
use Drupal\Core\Database\Database;

class FriendshipController extends ControllerBase {

  const FRIENDSHIP_PENDING = 0;
  const FRIENDSHIP_ACCEPTED = 1;
  const FRIENDSHIP_REJECTED = -1;
  const FRIENDSHIP_BESTFRIEND = 2;
  public function requestFriendship(Request $request) {
    $content = json_decode($request->getContent(), TRUE);

    // Validação básica dos dados recebidos
    if (empty($content['uid_1']) || empty($content['uid_2'])) {
      return new JsonResponse(['message' => t('Missing data.')], 400);
    }

    // Preparando dados para inserção - pode haver uma possibilidade de trazer o nivel de amizade
    $fields = [
      'uid_1' => $content['uid_1'],
      'uid_2' => $content['uid_2'],
      'level' => isset($content['level']) ? $content['level'] : self::FRIENDSHIP_PENDING,
      'from_date' => date('Y-m-d H:i:s'), // Data e hora atuais
    ];

    // Inserindo dados no banco de dados
    try {
      $connection = \Drupal::database();
      $connection->insert('friendship')
        ->fields($fields)
        ->execute();

      return new JsonResponse(['message' => t('Friendship request sent successfully.')]);
    } catch (\Exception $e) {
      watchdog_exception('friendship', $e);
      return new JsonResponse(['message' => t('An error occurred.')], 500);
    }
  }

  public function acceptFriendship(Request $request) {
    $content = json_decode($request->getContent(), TRUE);

    // Validação básica dos dados recebidos
    if (empty($content['uid_1']) || empty($content['uid_2'])) {
      return new JsonResponse(['message' => t('Missing user IDs.')], 400);
    }

    $uid_1 = $content['uid_1'];
    $uid_2 = $content['uid_2'];

    try {
      $connection = \Drupal::database();

      // Atualizando o campo 'level' para 1 na tabela de amizades
      $result = $connection->update('friendship')
          ->fields(['level' => self::FRIENDSHIP_ACCEPTED])
          ->condition('uid_1', $uid_1, '=')
          ->condition('uid_2', $uid_2, '=')
          ->execute();

      if ($result) {
          return new JsonResponse(['message' => t('Friendship accepted.')]);
      } else {
          return new JsonResponse(['message' => t('Friendship not found or already accepted.')], 404);
      }
    } catch (\Exception $e) {
      watchdog_exception('friendship', $e);
      return new JsonResponse(['message' => t('An error occurred.')], 500);
    }
  }

  public function rejectFriendship(Request $request) {
    $content = json_decode($request->getContent(), TRUE);

    // Validação básica dos dados recebidos
    if (empty($content['uid_1']) || empty($content['uid_2'])) {
      return new JsonResponse(['message' => t('Missing user IDs.')], 400);
    }

    $uid_1 = $content['uid_1'];
    $uid_2 = $content['uid_2'];

    try {
      $connection = \Drupal::database();

      // Atualizando o campo 'level' para -1 na tabela de amizades
      $result = $connection->update('friendship')
        ->fields(['level' => self::FRIENDSHIP_REJECTED])
        ->condition('uid_1', $uid_1, '=')
        ->condition('uid_2', $uid_2, '=')
        ->execute();

      if ($result) {
        return new JsonResponse(['message' => t('Friendship rejected.')]);
      } else {
        return new JsonResponse(['message' => t('Friendship not found or already rejected.')], 404);
      }
    } catch (\Exception $e) {
      watchdog_exception('friendship', $e);
      return new JsonResponse(['message' => t('An error occurred.')], 500);
    }
  }

  public function listFriendships(Request $request) {
    $uid = $request->query->get('uid');

    if (empty($uid) || !is_numeric($uid)) {
      return new JsonResponse(['message' => t('Valid User ID is required.')], 400);
    }

    if (!$this->currentUser()->hasPermission('administer users') && $this->currentUser()->id() != $uid) {
      return new JsonResponse(['message' => t('Access denied.')], 403);
    }

    try {
      $connection = \Drupal::database();

      // Consulta para buscar amizades do usuário, incluindo o campo 'first_name'
      $query = $connection->select('friendship', 'f');
      $query->fields('f', ['uid_1', 'uid_2', 'level', 'from_date']);

      // Adicionando join com a tabela de usuários para obter o 'first_name'
      $query->leftJoin('user__field_first_name', 'ufn', 'f.uid_1 = ufn.entity_id OR f.uid_2 = ufn.entity_id');
      $query->addField('ufn', 'field_first_name_value', 'first_name');

      $query->condition('f.uid_1', $uid, '=');
      $query->orWhere('f.uid_2', $uid, '=');

      $result = $query->execute()->fetchAll();

      return new JsonResponse(['friendships' => $result]);
    } catch (\Exception $e) {
      watchdog_exception('friendship', $e);
      return new JsonResponse(['message' => t('An error occurred.')], 500);
    }
  }


}
