<?php
header('Content-Type: application/json; charset=utf-8');
$file = __DIR__ . '/../data/clients.json';
if (!file_exists($file)) {
	echo json_encode([]);
	exit;
}
$content = file_get_contents($file);
// If file is invalid JSON, return empty array
$data = json_decode($content, true);
if ($data === null) $data = [];
echo json_encode($data, JSON_UNESCAPED_UNICODE);