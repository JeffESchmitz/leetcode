package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

const graphqlURL = "https://leetcode.com/graphql"

type questionData struct {
	FrontendID       string
	Title            string
	TitleSlug        string
	Difficulty       string
	Content          string
	GoSnippet        string
	ExampleTestcases string
	IsPaidOnly       bool
}

func httpClient() *http.Client { return &http.Client{Timeout: 15 * time.Second} }

func gqlPost(query string, vars map[string]any, out any) error {
	body, _ := json.Marshal(map[string]any{"query": query, "variables": vars})
	req, err := http.NewRequest(http.MethodPost, graphqlURL, bytes.NewReader(body))
	if err != nil {
		return err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Referer", "https://leetcode.com")
	req.Header.Set("User-Agent", "lc-cli/1.0")
	resp, err := httpClient().Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		b, _ := io.ReadAll(resp.Body)
		return fmt.Errorf("graphql HTTP %d: %s", resp.StatusCode, string(b))
	}
	return json.NewDecoder(resp.Body).Decode(out)
}

func fetchQuestion(slug string) (questionData, error) {
	const query = `query q($slug: String!) {
  question(titleSlug: $slug) {
    questionFrontendId
    title
    titleSlug
    difficulty
    content
    isPaidOnly
    codeSnippets { langSlug code }
    exampleTestcases
  }
}`
	var out struct {
		Data struct {
			Question *struct {
				QuestionFrontendID string `json:"questionFrontendId"`
				Title              string `json:"title"`
				TitleSlug          string `json:"titleSlug"`
				Difficulty         string `json:"difficulty"`
				Content            string `json:"content"`
				IsPaidOnly         bool   `json:"isPaidOnly"`
				CodeSnippets       []struct {
					LangSlug string `json:"langSlug"`
					Code     string `json:"code"`
				} `json:"codeSnippets"`
				ExampleTestcases string `json:"exampleTestcases"`
			} `json:"question"`
		} `json:"data"`
	}
	if err := gqlPost(query, map[string]any{"slug": slug}, &out); err != nil {
		return questionData{}, err
	}
	q := out.Data.Question
	if q == nil {
		return questionData{}, fmt.Errorf("problem %q not found", slug)
	}
	qd := questionData{
		FrontendID:       q.QuestionFrontendID,
		Title:            q.Title,
		TitleSlug:        q.TitleSlug,
		Difficulty:       q.Difficulty,
		Content:          q.Content,
		IsPaidOnly:       q.IsPaidOnly,
		ExampleTestcases: q.ExampleTestcases,
	}
	for _, s := range q.CodeSnippets {
		if s.LangSlug == "golang" {
			qd.GoSnippet = s.Code
		}
	}
	return qd, nil
}

func fetchDailySlug() (string, error) {
	const query = `query { activeDailyCodingChallengeQuestion { question { titleSlug } } }`
	var out struct {
		Data struct {
			ActiveDailyCodingChallengeQuestion struct {
				Question struct {
					TitleSlug string `json:"titleSlug"`
				} `json:"question"`
			} `json:"activeDailyCodingChallengeQuestion"`
		} `json:"data"`
	}
	if err := gqlPost(query, nil, &out); err != nil {
		return "", err
	}
	slug := out.Data.ActiveDailyCodingChallengeQuestion.Question.TitleSlug
	if slug == "" {
		return "", fmt.Errorf("could not resolve daily challenge")
	}
	return slug, nil
}
