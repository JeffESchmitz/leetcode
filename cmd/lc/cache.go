package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
)

const problemListURL = "https://leetcode.com/api/problems/all/"

func parseProblemMap(data []byte) (map[int]string, error) {
	var payload struct {
		Pairs []struct {
			Stat struct {
				ID   int    `json:"frontend_question_id"`
				Slug string `json:"question__title_slug"`
			} `json:"stat"`
		} `json:"stat_status_pairs"`
	}
	if err := json.Unmarshal(data, &payload); err != nil {
		return nil, err
	}
	m := make(map[int]string, len(payload.Pairs))
	for _, p := range payload.Pairs {
		m[p.Stat.ID] = p.Stat.Slug
	}
	return m, nil
}

func cachePath() string {
	dir, err := os.UserCacheDir()
	if err != nil {
		dir = os.TempDir()
	}
	return filepath.Join(dir, "lc", "problems.json")
}

func fetchProblemList() ([]byte, error) {
	resp, err := httpClient().Get(problemListURL)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("problem list HTTP %d", resp.StatusCode)
	}
	return io.ReadAll(resp.Body)
}

func loadProblemMap() (map[int]string, error) {
	path := cachePath()
	if data, err := os.ReadFile(path); err == nil {
		if m, err := parseProblemMap(data); err == nil && len(m) > 0 {
			return m, nil
		}
	}
	data, err := fetchProblemList()
	if err != nil {
		return nil, err
	}
	_ = os.MkdirAll(filepath.Dir(path), 0o755)
	_ = os.WriteFile(path, data, 0o644)
	return parseProblemMap(data)
}

func slugForNumber(n int) (string, error) {
	m, err := loadProblemMap()
	if err != nil {
		return "", err
	}
	slug, ok := m[n]
	if !ok {
		return "", fmt.Errorf("problem number %d not found", n)
	}
	return slug, nil
}
