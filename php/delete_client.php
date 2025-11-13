<?php
header('Content-Type: application/json; charset=utf-8');
$file = __DIR__ . '/../data/clients.json';
$data = [];
if (file_exists($file)) {
	$content = file_get_contents($file);
	$data = json_decode($content, true) ?: [];
}

$index = isset($_POST['index']) ? intval($_POST['index']) : null;
if ($index === null || !isset($data[$index])) {
	echo json_encode(['success' => false, 'message' => 'Invalid index']);
	exit;
}

array_splice($data, $index, 1);
file_put_contents($file, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE), LOCK_EX);
echo json_encode(['success' => true, 'data' => $data], JSON_UNESCAPED_UNICODE);