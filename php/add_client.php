<?php
header('Content-Type: application/json; charset=utf-8');
$file = __DIR__ . '/../data/clients.json';
$data = [];
if (file_exists($file)) {
	$content = file_get_contents($file);
	$data = json_decode($content, true) ?: [];
}

$name = trim($_POST['name'] ?? '');
if ($name === '') {
	echo json_encode(['success' => false, 'message' => 'Name is required']);
	exit;
}

$data[] = ['name' => $name];
file_put_contents($file, json_encode($data, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE), LOCK_EX);
echo json_encode(['success' => true, 'data' => $data], JSON_UNESCAPED_UNICODE);